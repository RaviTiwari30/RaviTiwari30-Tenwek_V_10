using System;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for LabOPD
/// </summary>
public class LabOPD
{
	public LabOPD()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static DataSet getDataSetForReport(string TestID, string PatientID, DataTable dtAllInvestigation, string LabType,string TransactionID,bool aa)
    {
        DataSet dsPrintReoprt = new DataSet();
        if (TestID.Trim() != string.Empty)
        {
            AllQuery AQ = new AllQuery();
            DataTable dtResult = new DataTable();
            DataTable dtList = dtAllInvestigation.Clone();
            dtList.TableName = "InvestigationToPrint";
            dtList.Clear();            

            DataRow[] dr = dtAllInvestigation.Select("test_ID in (" + TestID + ")");

            foreach (DataRow dc in dr)
            {
                DataRow drList = dtList.NewRow();
                drList.ItemArray = dc.ItemArray;
                dtList.Rows.Add(drList);
            }

            if (LabType == "IPD")
            {
                if (dtList.Rows[0]["ReportType"].ToString() == "3")
                {
                    dtResult = AQ.GetInvestigationResult(TestID);
                }
                else if (dtList.Rows[0]["ReportType"].ToString() == "5")
                {
                    dtResult = AQ.GetInvestigationRadioResult(TestID);
                }
            }
            else                
            {
                if (dtList.Rows[0]["ReportType"].ToString() == "3")
                {
                    dtResult = AQ.GetInvestigationResult(TestID);
                }
                else if (dtList.Rows[0]["ReportType"].ToString() == "5")
                {
                    dtResult = AQ.GetInvestigationRadioResult(TestID);
                }
            }

            DataTable dtDetails = new DataTable();          
            DataTable dtLabID = AQ.GetLabID(TestID, LabType);
            string sql = "select pm.PatientID,concat(Title,' ',PName)PName,Title,Pname PPName,Age, "+
                            " Gender,House_No,Street_Name,Locality,City,Pincode,Relation, "+
                            " RelationName,MaritalStatus,Phone,Mobile,(select Name from doctor_master where DoctorID = pmh.DoctorID ) DoctorName,(select distinct Department  from doctor_hospital where DoctorID = pmh.DoctorID )  Specialization   " +
                             " from patient_master pm inner join patient_medical_history pmh on pmh.PatientID = pm.PatientID "+
                            " where pmh.TransactionID='"+TransactionID+"' ";
            DataTable dtPatient = StockReports.GetDataTable(sql);

            DataTable limitText = AQ.GetLimitation(dr[0]["InvestigationId"].ToString());
            string Approved = "APPROVED";
            
            if (dtLabID != null && dtLabID.Rows.Count > 0)
            {
                 dtPatient.Columns.Add("LedgerTransactionNo");
                dtPatient.Columns.Add("SerialNo");
                 dtPatient.Columns.Add("IsApproved");
                dtPatient.Rows[0]["LedgerTransactionNo"] = dtLabID.Rows[0]["LedgerTransactionNo"].ToString();                
                dtPatient.Rows[0]["IsApproved"] = Approved;
            }

            if (dtPatient.Columns.Contains("BedNo") == false) dtPatient.Columns.Add("BedNo");
            dtPatient.Rows[0]["BedNo"] = "";            

            string limitationText = "";
            if (limitText != null && limitText.Rows.Count > 0)
            {
                limitationText = limitText.Rows[0]["LabInves_Description"].ToString();
            }
            
            foreach (DataColumn dc in dtPatient.Columns)
            {
                dtDetails.Columns.Add(dc.ColumnName);
            }

            dtDetails.Columns.Add("FileLimitationName");
            DataRow drDetail = dtDetails.NewRow();
            foreach (DataColumn dc in dtPatient.Columns)
            {
                drDetail[dc.ColumnName] = dtPatient.Rows[0][dc.ColumnName].ToString();
            }
            
            drDetail["FileLimitationName"] = limitationText;
            dtDetails.Rows.Add(drDetail);
            if (dtResult != null && dtResult.Rows.Count > 0)
            {
                dsPrintReoprt.Tables.Add(dtResult.Copy());
            }
            dsPrintReoprt.Tables.Add(dtDetails.Copy());
            dsPrintReoprt.Tables.Add(dtList.Copy());
        }
        return dsPrintReoprt;
    }
    
    
    public static DataTable getLabToPrint(string TID,string LabType)
    {
        System.Text.StringBuilder str = new System.Text.StringBuilder();

      
        str.Append(" select distinct DeptName,LabInvestigationOPD_ID,RoleID Role_ID,Date,SampleDate,InvestigationID,TransactionID,Test_ID,LabInves_Description,ID,RoleID,ObservationType_ID,LedgerTransactionNo, ");
        str.Append(" Investigation_Id,Name,ReportType,FileLimitationName,Department, ");
        str.Append(" DoctorName,Designation,Dept,Validation ,Remarks, IsPrint,case IsPrint when '' then 'false' else 'true' end IsEnter ");
        str.Append(" from  ");
        str.Append(" ( ");
        str.Append(" select plo.*,im.Investigation_Id,im.Name,im.ReportType,im.FileLimitationName,om.Name Department,  ");
        str.Append(" lf.DoctorName,Designation,Dept,Validation ,ifnull(EPI.Remarks,'')Remarks,ifnull(EPI.IsPrint,'')IsPrint from Investigation_master im inner join   ");
        str.Append(" (select LabInvestigationOPD_ID,date_format(date,'%d-%b-%y') as Date,SampleDate,pli.Investigation_ID as InvestigationID,TransactionID,Test_ID,  ");
        str.Append(" LabInves_Description,pli.ID,RoleID,iot.ObservationType_ID,LedgerTransactionNo   ");
        str.Append(" ,otm.Name DeptName ");
        str.Append(" from patient_labinvestigation_opd pli inner join investigation_observationtype iot on iot.Investigation_ID = pli.Investigation_ID   ");
        str.Append(" inner join f_categoryrole cr on  cr.ObservationType_ID=iot.ObservationType_ID   ");
        str.Append(" inner join observationtype_master otm on otm.ObservationType_ID=iot.ObservationType_ID ");
        str.Append(" where result_flag=1 and pli.TransactionID='" + TID + "' and pli.result_flag=1 and pli.Approved=1   ");
        str.Append(" ) plo   ");
        str.Append(" on plo.InvestigationID = im.Investigation_Id  ");
        str.Append(" inner join observationtype_master om on om.observationtype_Id = plo.observationtype_ID  ");
        str.Append(" left outer join labdept_footer lf on lf.roleID = plo.roleID  ");
        str.Append(" left outer join emr_patient_investigation EPI on (EPI.TransactionID=plo.TransactionID and EPI.Investigation_ID=plo.InvestigationID  and EPI.Test_ID=plo.Test_ID )  ");
        str.Append(" ) aa ");

        DataTable dtConcated = new DataTable("InvestigationToPrint");
        dtConcated = StockReports.GetDataTable(str.ToString());
        return dtConcated;

    }
    public static DataTable getLabToPrint(string LedgerTransactionNo)
    {
        string str = "";
        str = "select plo.*,im.Investigation_Id,im.Name,im.ReportType,im.FileLimitationName,om.Name Department, " +
        "lf.DoctorName,Designation,Dept,Validation from Investigation_master im inner join  " +
        "(select date_format(date,'%d-%b-%y') as Date,SampleDate,Investigation_ID as InvestigationID,TransactionID,Test_ID, " +
        "LabInves_Description,ID,RoleID,ObservationType_ID,LedgerTransactionNo from patient_labinvestigation_opd  " +
        "where result_flag=1 and LedgerTransactionNo='" + LedgerTransactionNo + "') plo on plo.InvestigationID = im.Investigation_Id " +
        "inner join observationtype_master om on om.observationtype_Id = plo.observationtype_ID " +
        "inner join labdept_footer lf on lf.roleID = plo.roleID ";

        DataTable dtConcated = new DataTable("InvestigationToPrint");
        dtConcated = StockReports.GetDataTable(str);
        return dtConcated;
    }
    public static DataTable getLabToPrint(string PatientID, DateTime FromDate,DateTime ToDate)
    { 
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);
        
        try
        {

            AllQuery AQ = new AllQuery(MySqltrans);
            DataTable dtListInv = AQ.GetInvestigationList(PatientID, FromDate.ToString(), ToDate.ToString());
            string invest = "";
            if (dtListInv != null)
            {
                foreach (DataRow dr in dtListInv.Rows)
                {
                    invest = invest+"'" + dr["InvestigationID"].ToString() + "',";
                }
                invest = invest.Substring(0, invest.Length - 1);

                DataTable dtInvestName = AQ.GetInvestigationName(invest);
                DataTable dtConcated = new DataTable("InvestigationToPrint");
                foreach (DataColumn dc in dtListInv.Columns)
                {
                    dtConcated.Columns.Add(dc.ColumnName);
                }

                foreach (DataColumn dc in dtInvestName.Columns)
                {
                    dtConcated.Columns.Add(dc.ColumnName);
                }

                foreach (DataRow dr in dtListInv.Rows)
                {//date_format(date,'%d-%m-%y'),SampleDate,Investigation_ID,TransactionID,Test_ID
                    DataRow drCon = dtConcated.NewRow();
                    drCon["Date"] = dr["Date"].ToString();
                    drCon["SampleDate"] = dr["SampleDate"].ToString();
                    drCon["InvestigationID"] = dr["InvestigationID"].ToString();
                    drCon["TransactionID"] = dr["TransactionID"].ToString();
                    drCon["Test_ID"] = dr["Test_ID"].ToString();
                    drCon["LabInves_Description"] = dr["LabInves_Description"].ToString();
                    DataRow[] drInName = dtInvestName.Select("Investigation_ID = '" + dr["InvestigationID"].ToString() + "'");
                    drCon["Name"] = drInName[0]["Name"].ToString();
                    drCon["ReportType"] = drInName[0]["ReportType"].ToString();
                    drCon["FileLimitationName"] = drInName[0]["FileLimitationName"].ToString();
                    dtConcated.Rows.Add(drCon);
                }
                return dtConcated;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            MySqltrans.Rollback();
            con.Close();
            con.Dispose();
            return null;
        }
    }

    public static DataTable getLabToPrintNew(string LedgerTransactionNo, string LabType, string TransactionID,string ReportType)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            AllQuery AQ = new AllQuery(MySqltrans);
            DataTable dtListInv = new DataTable();

            if (LedgerTransactionNo != "")
            {
                dtListInv = AQ.GetInvestigationListNew(LedgerTransactionNo, LabType, ReportType);
            }
            else if (TransactionID != "")
            {
                dtListInv = AQ.GetInvestigationListWard(LedgerTransactionNo, LabType, TransactionID);
            }

            string invest = "";
            if (dtListInv != null)
            {
                foreach (DataRow dr in dtListInv.Rows)
                {
                    invest = invest + "'" + dr["InvestigationID"].ToString() + "',";
                }
                invest = invest.Substring(0, invest.Length - 1);

                DataTable dtInvestName = AQ.GetInvestigationName(invest);

                MySqltrans.Commit();
              


                DataTable dtConcated = new DataTable("InvestigationToPrint");
                foreach (DataColumn dc in dtListInv.Columns)
                {
                    dtConcated.Columns.Add(dc.ColumnName);
                }

                foreach (DataColumn dc in dtInvestName.Columns)
                {
                    dtConcated.Columns.Add(dc.ColumnName);
                }

                foreach (DataRow dr in dtListInv.Rows)
                {//date_format(date,'%d-%m-%y'),SampleDate,Investigation_ID,TransactionID,Test_ID
                    DataRow drCon = dtConcated.NewRow();
                    drCon["Time"] = dr["Time"].ToString();
                    drCon["Date"] = dr["Date"].ToString();
                    drCon["SampleDate"] = dr["SampleDate"].ToString();
                    drCon["InvestigationID"] = dr["InvestigationID"].ToString();
                    drCon["TransactionID"] = dr["TransactionID"].ToString();
                    drCon["Test_ID"] = dr["Test_ID"].ToString();
                    drCon["LabInves_Description"] = dr["LabInves_Description"].ToString();
                    DataRow[] drInName = dtInvestName.Select("Investigation_ID = '" + dr["InvestigationID"].ToString() + "'");
                    drCon["Name"] = drInName[0]["Name"].ToString();
                    drCon["ReportType"] = drInName[0]["ReportType"].ToString();
                    drCon["FileLimitationName"] = drInName[0]["FileLimitationName"].ToString();
                    drCon["Department"] = drInName[0]["Department"].ToString();
                    drCon["Print_Sequence"] = drInName[0]["Print_Sequence"].ToString();
                    drCon["ID"] = dr["ID"].ToString();
                    drCon["Approved"] = dr["Approved"].ToString();

                    dtConcated.Rows.Add(drCon);
                }
                return dtConcated;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            MySqltrans.Rollback();
            
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public static DataTable getLabToPrint(string LedgerTransactionNo, string LabType, string TransactionID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);
        
        try
        {
            AllQuery AQ = new AllQuery(MySqltrans);
            DataTable dtListInv = new DataTable();

            if (LedgerTransactionNo != "")
            {
                dtListInv = AQ.GetInvestigationList(LedgerTransactionNo, LabType);
            }
            else if (TransactionID != "")
            {
                dtListInv = AQ.GetInvestigationListWard(LedgerTransactionNo, LabType, TransactionID);
            }

            string invest = "";
            if (dtListInv != null)
            {
                foreach (DataRow dr in dtListInv.Rows)
                {
                    invest = invest + "'" + dr["InvestigationID"].ToString() + "',";
                }
                invest = invest.Substring(0, invest.Length - 1);

                DataTable dtInvestName = AQ.GetInvestigationName(invest);

                MySqltrans.Commit();

                DataTable dtConcated = new DataTable("InvestigationToPrint");
                foreach (DataColumn dc in dtListInv.Columns)
                {
                    dtConcated.Columns.Add(dc.ColumnName);
                }

                foreach (DataColumn dc in dtInvestName.Columns)
                {
                    dtConcated.Columns.Add(dc.ColumnName);
                }

                foreach (DataRow dr in dtListInv.Rows)
                {//date_format(date,'%d-%m-%y'),SampleDate,Investigation_ID,TransactionID,Test_ID
                    DataRow drCon = dtConcated.NewRow();
                    drCon["Time"] = dr["Time"].ToString();
                    drCon["Date"] = dr["Date"].ToString();
                    drCon["SampleDate"] = dr["SampleDate"].ToString();
                    drCon["InvestigationID"] = dr["InvestigationID"].ToString();
                    drCon["TransactionID"] = dr["TransactionID"].ToString();
                    drCon["Test_ID"] = dr["Test_ID"].ToString();
                    drCon["LabInves_Description"] = dr["LabInves_Description"].ToString();
                    drCon["DoctorID"] = dr["DoctorID"].ToString();
                    DataRow[] drInName = dtInvestName.Select("Investigation_ID = '" + dr["InvestigationID"].ToString() + "'");
                    drCon["Name"] = drInName[0]["Name"].ToString();
                    drCon["ReportType"] = drInName[0]["ReportType"].ToString();
                    drCon["FileLimitationName"] = drInName[0]["FileLimitationName"].ToString();
                    drCon["Department"] = drInName[0]["Department"].ToString();
                    drCon["Print_Sequence"] = drInName[0]["Print_Sequence"].ToString();
                    drCon["ID"] = dr["ID"].ToString();
                    drCon["Approved"] = dr["Approved"].ToString();
                   
                    dtConcated.Rows.Add(drCon);
                }
                return dtConcated;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            MySqltrans.Rollback();
           
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public static DataSet getDataSetForReport(string TestID, string PatientID, DataTable dtAllInvestigation, string LabType, string SerialNo)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataSet dsPrintReoprt = new DataSet();
            if (TestID.Trim() != string.Empty)
            {
                AllQuery AQ = new AllQuery(MySqltrans);
                DataTable dtResult = new DataTable();
                DataTable dtList = dtAllInvestigation.Clone();

                //DataRow drList = dtList.NewRow();

                DataRow[] dr = dtAllInvestigation.Select("test_ID in (" + TestID + ")");

                //foreach (DataColumn dc in dtAllInvestigation.Columns)
                //{
                //    drList[dc.ColumnName] = dr[0][dc.ColumnName].ToString();
                //}

                int i = 0;
                foreach (DataRow dc in dr)
                {
                    dtList.LoadDataRow(dc.ItemArray, true);
                    if (dtList.Rows[0]["ReportType"].ToString() == "5")
                    {
                        dtList.Rows[i]["labInves_Description"] = "<center><b>" + dtList.Rows[i]["Name"].ToString() + "</b></center><br>" + dtList.Rows[i]["labInves_Description"].ToString();
                    }
                    else
                    {
                        dtList.Rows[i]["labInves_Description"] = "<br>" + dtList.Rows[i]["labInves_Description"].ToString().Replace("Â", "");
                    }
                    i++;
                    //DataRow drList = dtList.NewRow();
                    //drList.ItemArray = dc.ItemArray;
                    //dtList.Rows.Add(drList);
                }


                //dtList.Rows.Add(drList);

                
                    if (dtList.Rows[0]["ReportType"].ToString() == "1")
                    {
                        dtResult = AQ.GetInvestigationResult(TestID);
                    }
                    else if (dtList.Rows[0]["ReportType"].ToString() == "5")
                    {
                        dtResult = AQ.GetInvestigationRadioResult(TestID);
                    }
                DataTable dtDetails = new DataTable();

                DataTable dtPatient = AQ.GetPatientDetail(PatientID);
                DataTable dtLabID = AQ.GetLabID(TestID, LabType);
                DataTable dtDoctor = new DataTable();

                if (LabType == "IPD")
                {
                    dtDoctor = StockReports.GetDataTable("select DoctorID,Name,Specialization from doctor_master where DoctorID =(select DoctorID from patient_medical_history where TransactionID ='" + dr[0]["TransactionID"].ToString() + "')");
                }
                else
                {
                    dtDoctor = AQ.GetDoctorDetails(dr[0]["TransactionID"].ToString());
                }
                DataTable limitText = AQ.GetLimitation(dr[0]["InvestigationId"].ToString());
                string InvestigationID = string.Empty;
                
                if (dtLabID != null && dtLabID.Rows.Count > 0)
                {
                    if (dtPatient.Columns.Contains("LedgerTransactionNo") == false) dtPatient.Columns.Add("LedgerTransactionNo");
                    if (dtPatient.Columns.Contains("SerialNo") == false) dtPatient.Columns.Add("SerialNo");
                    if (dtPatient.Columns.Contains("Approved") == false) dtPatient.Columns.Add("Approved");
                    if (dtPatient.Columns.Contains("ApprovedBy") == false) dtPatient.Columns.Add("ApprovedBy");
                    
                    if (dtPatient.Columns.Contains("ApprovedDate") == false) dtPatient.Columns.Add("ApprovedDate");
                    if (dtPatient.Columns.Contains("ResultEnteredName") == false) dtPatient.Columns.Add("ResultEnteredName");

                    dtPatient.Rows[0]["LedgerTransactionNo"] = dtLabID.Rows[0]["LedgerTransactionNo"].ToString();
                    dtPatient.Rows[0]["SerialNo"] = SerialNo;
                    dtPatient.Rows[0]["Approved"] = dtLabID.Rows[0]["Approved"].ToString();
                    dtPatient.Rows[0]["ApprovedBy"] = dtLabID.Rows[0]["ApprovedBy"].ToString();

                    dtPatient.Rows[0]["ApprovedDate"] = dtLabID.Rows[0]["ApprovedDate"].ToString();
                    dtPatient.Rows[0]["ResultEnteredName"] = dtLabID.Rows[0]["ResultEnteredName"].ToString();

                }

                if (dtPatient.Columns.Contains("BedNo") == false) dtPatient.Columns.Add("BedNo");
                if (LabType == "IPD")
                {
                    DataTable dtBedNo = AQ.GetPatientBedNoByTID(dr[0]["TransactionID"].ToString());

                    if (dtBedNo != null && dtBedNo.Rows.Count > 0)
                    {
                        dtPatient.Rows[0]["BedNo"] = dtBedNo.Rows[0]["Name"].ToString();
                    }
                }
                else
                {
                    dtPatient.Rows[0]["BedNo"] = "";
                }

                MySqltrans.Commit();
                con.Close();
                con.Dispose();


                string limitationText = "";
                if (limitText != null && limitText.Rows.Count > 0)
                {
                    limitationText = limitText.Rows[0]["LabInves_Description"].ToString();
                }
                foreach (DataColumn dc in dtPatient.Columns)
                {
                    dtDetails.Columns.Add(dc.ColumnName);
                }

                foreach (DataColumn dc in dtDoctor.Columns)
                {
                    dtDetails.Columns.Add(dc.ColumnName);
                }
                dtDetails.Columns.Add("FileLimitationName");
                DataRow drDetail = dtDetails.NewRow();
                foreach (DataColumn dc in dtPatient.Columns)
                {
                    drDetail[dc.ColumnName] = dtPatient.Rows[0][dc.ColumnName].ToString();
                }
                foreach (DataColumn dc in dtDoctor.Columns)
                {
                    drDetail[dc.ColumnName] = dtDoctor.Rows[0][dc.ColumnName].ToString();
                }
                drDetail["FileLimitationName"] = limitationText;


                dtDetails.Rows.Add(drDetail);
                if (dtResult != null && dtResult.Rows.Count > 0)
                {
                    dsPrintReoprt.Tables.Add(dtResult.Copy());
                }
                dsPrintReoprt.Tables.Add(dtDetails.Copy());
                dsPrintReoprt.Tables.Add(dtList.Copy());
                // dsPrintReoprt.Tables.Add(dtHeader.Copy());
            }
            return dsPrintReoprt;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            MySqltrans.Rollback();
            con.Close();
            con.Dispose();
            return null;
        }
    }
    public static string UpdateSampleStatus(MySqlTransaction tnx, string Test_ID, string Employee_ID, string EmployeeName, int CenterID, int RoleID, string Status, string DispatchCode)
    {
        if (tnx == null)
        {
            return "0";
        }
        try
        {
            string str = "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID, " +
                         "STATUS,UserID,UserName,IpAddress,CentreID,RoleID,DispatchCode) " +
                         "(SELECT plo.LedgerTransactionNo,plo.BarcodeNo,plo.Test_ID,'" + Status + "','" + Employee_ID + "','" + EmployeeName + "','" + All_LoadData.IpAddress() + "','" + CenterID + "','" + RoleID + "','" + DispatchCode + "' FROM patient_labinvestigation_opd plo WHERE plo.Test_ID='" + Test_ID + "')";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
}
