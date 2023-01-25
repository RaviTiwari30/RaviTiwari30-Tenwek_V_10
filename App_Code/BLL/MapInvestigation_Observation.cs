using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for MapInvestigation_Observation
/// </summary>
public class MapInvestigation_Observation
{
    public MapInvestigation_Observation()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable Get_Observation(string InvestigationID)
    {
        StringBuilder sb = new StringBuilder();
        sb = new StringBuilder();
        sb.Append(" SELECT LOM.LabObservation_ID, LOM.Name as ObsName,LOM.Minimum,LOM.Maximum,LOM.MinFemale,LOM.MaxFemale,LOM.MinChild,LOM.MaxChild,LOM.ReadingFormat, '0' printOrder,'0' Child_Flag  FROM labobservation_master lom WHERE lom.LabObservation_ID NOT IN   ");
        sb.Append(" (SELECT loi.labObservation_ID FROM labobservation_investigation loi WHERE   ");
        sb.Append(" loi.Investigation_Id='" + InvestigationID + "') GROUP BY lom.name ORDER BY lom.name ");
        DataTable dtAvailObs = new DataTable();
        dtAvailObs = StockReports.GetDataTable(sb.ToString());
        return dtAvailObs;

    }
    public string getFormula(string labobservation_id, string formula, string Name)
    {
        string value = "";
        StringBuilder sb = new StringBuilder();
        sb = new StringBuilder();
        sb.Append("SELECT ifnull(formulatext,'')formulatext,NAME FROM labobservation_master WHERE labobservation_id='" + labobservation_id + "'");

        DataTable dtAvailObs = new DataTable();
        dtAvailObs = StockReports.GetDataTable(sb.ToString());
        if (dtAvailObs.Rows.Count > 0)
        {
            if (dtAvailObs.Rows[0]["formulatext"].ToString() != "")
            {

                value = labobservation_id + "$" + dtAvailObs.Rows[0]["formulatext"].ToString() + "$" + dtAvailObs.Rows[0]["Name"].ToString() + "|1";
            }
        }
        return value;

    }
    public string DelFormula(string labobservation_id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE labobservation_master SET formula='',formulaText='' WHERE labobservation_id='" + labobservation_id + "'");
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public DataTable Bind_Investigation()
    {
         StringBuilder sb = new StringBuilder();
           sb = new StringBuilder();
           sb.Append(" select  CONCAT(IFNULL(im.ItemCode,''),' # ',inv.Name)Name,inv.Investigation_id from f_itemmaster im   " );
           sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  " );
           sb.Append(  " inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
           sb.Append(" inner join investigation_master inv on inv.Investigation_id=im.Type_id   ");
           sb.Append(" INNER JOIN investigation_observationtype io ON inv.Investigation_Id = io.Investigation_ID ");
           sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID =io.ObservationType_Id");
           sb.Append(" and c.ConfigID='3' and im.IsActive=1  and cr.RoleID='" + HttpContext.Current.Session["RoleID"] + "' ");
         
           sb.Append("  order by inv.Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;

    }

    public DataTable BindInvListBox(string Dept)
    {
        StringBuilder sb = new StringBuilder();
        sb = new StringBuilder();
        sb.Append(" SELECT   CONCAT(IFNULL(it.ItemCode,''),' # ',im.Name)NAME,CAST(CONCAT(IFNULL(om.ObservationType_ID,''),'$',IFNULL(om.Name,''),'$',IFNULL(im.Name,''),'$',IFNULL(im.Type,''),'$',  ");
        sb.Append(" IFNULL(im.ReportType,''),'$',IFNULL(im.Print_Sequence,''),'$',IFNULL(im.Investigation_Id,''),'$',IFNULL(io.Investigation_ObservationType_ID,''),'$',IFNULL(it.ItemID,''),'$',IFNULL(im.Description,''),'$',IFNULL(im.principle,''),'$',IFNULL(it.IsTrigger,''),'$', ");
        sb.Append(" IFNULL(im.SampleQty,''),'$',IFNULL(im.printHeader,''),'$',IFNULL(im.GenderInvestigate,''),'$',IFNULL(im.SampleTypeID,''),'$',IFNULL(it.ItemCode,''),'$',IFNULL(it.IsActive,''),'$',im.IsOutSource,'$',it.RateEditable,'$',im.IsUrgent,'$',im.PrintHeader,'$', ");
        sb.Append(" im.ShowOnline,'$',im.PrintSeperate,'$',im.PrintSampleName,'$',IFNULL((select Name from Type_Master where ID=it.DeptID AND TypeID=5),''),'$',it.IsDiscountable,'$',it.DeptID,'$',im.IsCulture,'$',im.SampleContainer)  ");
        sb.Append(" AS CHAR) newValue FROM observationtype_master om  ");
        sb.Append(" INNER JOIN investigation_observationtype io ON om.ObservationType_ID = io.ObservationType_Id   ");
        if (Dept != "ALL")
            sb.Append(" and io.ObservationType_Id='" + Dept + "'");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id = io.Investigation_ID   ");
        sb.Append(" AND im.Name<>'' ");
        sb.Append(" INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID  INNER JOIN f_categoryrole cr ON cr.ObservationType_ID =io.ObservationType_Id    ");
        sb.Append(" INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigID=3  and cr.RoleID='" + HttpContext.Current.Session["RoleID"] + "' ");
        sb.Append(" ORDER BY im.Name ");

        DataTable dt1 = StockReports.GetDataTable(sb.ToString());

        return dt1;
    }


    public DataTable GetObservation_Data(string InvestigationID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("select IM.Investigation_Id,IM.Name,LOM.LabObservation_ID,CONCAT(LOM.Name,' ' ,IFNULL(Lom.Suffix,'')) as ObsName,LOI.IsCritical, ");
        sb.Append("loi.Child_Flag,LOI.MethodName,Loi.Prefix,loi.IsBold,loi.IsUnderLine,LOM.IsComment,loi.ParentID, ");
        sb.Append("loi.IsMicroScopy,lom.LabObservation_ID  AS ObsID ");
        sb.Append("from investigation_master IM inner join labobservation_investigation LOI ");
        sb.Append("ON IM.Investigation_Id=LOI.Investigation_Id inner join labobservation_master LOM ON ");
        sb.Append("LOI.labObservation_ID=LOM.LabObservation_ID where  IM.Investigation_Id='" + InvestigationID + "' order by loi.printOrder ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public string cptcode(string CPT)
    {

        DataTable dt = StockReports.GetDataTable("SELECT itemcode FROM f_itemmaster WHERE itemcode='" + CPT + "' ");
        if (dt.Rows.Count > 0)
            return "1";
        else
            return "0";
    }
    public string SaveMapping(string InvestigationID, string ObsData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // ObsData= ObservationId|Prefix|SampleTypeName|SampleTypeID|Method|Header|IsCritical#
            ObsData = ObsData.TrimEnd('#');

            string str = "";
            int len = Util.GetInt(ObsData.Split('#').Length);
            string[] Data = new string[len];
            Data = ObsData.Split('#');
            for (int i = 0; i < len; i++)
            {
                str = "UPDATE labobservation_investigation Set printOrder=" + (Util.GetInt(i) + 1) + ",Prefix='" + Data[i].Split('|')[1].Replace(" ", "&nbsp;") + "',MethodName='" + Util.GetString(Data[i].Split('|')[2]) + "',Child_Flag='" + Data[i].Split('|')[3].ToString() + "',IsCritical='" + Data[i].Split('|')[4].ToString() + "',UpdateID='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateName='" + HttpContext.Current.Session["LoginName"].ToString() + "',UpdateRemarks='',UpdateDate='" + System.DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "',IsBold='" + Data[i].Split('|')[5].ToString() + "',IsUnderLine='" + Data[i].Split('|')[6].ToString() + "',ParentID='" + Data[i].Split('|')[9].ToString() + "',IsMicroscopy='" + Data[i].Split('|')[8].ToString() + "' where labObservation_ID='" + Data[i].Split('|')[0].ToString() + "' and Investigation_Id='" + InvestigationID + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                str = "UPDATE labobservation_master Set IsComment = '" + Data[i].Split('|')[7].ToString() + "',Suffix='" + Data[i].Split('|')[1].Replace(" ", "&nbsp;") + "' where LabObservation_ID='" + Data[i].Split('|')[0] + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveObservation(string InvestigationID, string ObservationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
           
           
            int MaxPrintOrder = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select max(printOrder) from labobservation_investigation where Investigation_Id= '" + InvestigationID + "'"));
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text,"Insert into labobservation_investigation(Investigation_Id,labObservation_ID,printOrder,Creator_ID) values('" + InvestigationID + "','" + ObservationId + "','" + (MaxPrintOrder + 1) + "','" + HttpContext.Current.Session["ID"].ToString() + "')  ");            
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string RemoveObservation(string InvestigationID, string ObservationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
	    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO labobservation_investigation_tgankur (Investigation_ID,labObservation_ID,DeleteBy) VALUES ('" + InvestigationID + "','" + ObservationId + "','" + HttpContext.Current.Session["ID"].ToString() + "')  ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from  labobservation_investigation where labObservation_ID='" + ObservationId + "'and Investigation_Id='" + InvestigationID + "'  ");
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveNewInvestigation(string InvName, string Description, string DepartmentID, string DepartmentName, string ReportType, string SampleType, string PrintSequence, string Gender, string Principle, string sampletypename, string CPTCode, string outsource, int RateEditable, int IsUrgent, int ShowPtRpt, int ShowOnlineRpt, int PrintSeperate, int PrintSampleName, int DeptID, int IsDiscountable, string SampleTypeID, string IsCulture, string SampleContainer)
    {
        LoadCacheQuery.dropCache("OPDDiagnosisItems");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string value = "";
        try
        {
            int InvCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select count(*) from investigation_master where name='" + InvName + "'").ToString());
            if (InvCount > 0)
            {               
                return "0";
            }
            int maxprintseq = 0;
            maxprintseq = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT MAX(Print_Sequence) Print_Sequence FROM investigation_master im INNER JOIN investigation_observationtype io ON io.Investigation_ID=im.Investigation_Id WHERE ObservationType_Id='" + DepartmentID + "' "));

            string s = sampletypename.ToString();
            if (s == "Select")
            {
                s = "";
            }

            string Investigation_ID = "";
            Investigation_Master objInvestigation_Master = new Investigation_Master(Tranx);
            objInvestigation_Master.Creator_ID = HttpContext.Current.Session["ID"].ToString();
            objInvestigation_Master.Name = InvName.Trim();
            objInvestigation_Master.Description = Description.Trim();
            objInvestigation_Master.Ownership = "Public";
            objInvestigation_Master.ReportType = Util.GetInt(ReportType);
            objInvestigation_Master.FileLimitationName = "";
            objInvestigation_Master.Group_ID = "";
            objInvestigation_Master.Type = SampleType;
            objInvestigation_Master.Print_Sequence = Util.GetInt(maxprintseq+1);
            objInvestigation_Master.Principle = Principle.Trim();
            objInvestigation_Master.GenderInvestigate = Gender;
            objInvestigation_Master.sampletypename = s;
            objInvestigation_Master.IsOutSource = Util.GetInt(outsource);
            objInvestigation_Master.IpAddress = HttpContext.Current.Request.UserHostAddress;
            // objInvestigation_Master.IsNabl = Util.GetInt(IsNabl);
            objInvestigation_Master.IsUrgent = IsUrgent;
            objInvestigation_Master.ShowPtRpt = ShowPtRpt;
            objInvestigation_Master.ShowOnlineRpt = ShowOnlineRpt;
            objInvestigation_Master.PrintSeperate = PrintSeperate;
            objInvestigation_Master.PrintSampleName = PrintSampleName;
            objInvestigation_Master.SampleTypeID = SampleTypeID;
            objInvestigation_Master.IsCulture = IsCulture;
            objInvestigation_Master.SampleContainer = SampleContainer;
            Investigation_ID = objInvestigation_Master.Insert();

            Investigation_ObservationType objInves_ObservationType = new Investigation_ObservationType(Tranx);
            objInves_ObservationType.ObservationType_ID = DepartmentID;
            objInves_ObservationType.Investigation_ID = Investigation_ID;
            objInves_ObservationType.Ownership = "Public";
            objInves_ObservationType.Creator_ID = HttpContext.Current.Session["ID"].ToString();

            int InvObsId = objInves_ObservationType.Insert();

            string SubCategoryID =Util.GetString( MySqlHelper.ExecuteScalar(con,CommandType.Text, "Select sc.SubCategoryID from f_subcategorymaster sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID where cf.ConfigID=3 and sc.Name='" + DepartmentName + "'"));

            string ItemId = "";
            if (SubCategoryID != "")
            {
                ItemMaster objIMaster = new ItemMaster(Tranx);
                objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objIMaster.Type_ID = Util.GetInt(Investigation_ID);
                objIMaster.TypeName = InvName.Trim();
                objIMaster.Description = "";
                objIMaster.SubCategoryID = SubCategoryID;
                objIMaster.IsActive = 1;
                objIMaster.IsAuthorised = 1;
                objIMaster.IsEffectingInventory = "NO";
                objIMaster.ItemCode = CPTCode;
                objIMaster.RateEditable = RateEditable;
                objIMaster.DepartmentID = DeptID;
                objIMaster.IsDiscountable = IsDiscountable;
                ItemId = objIMaster.Insert().ToString();
            }
            else
            {
                Tranx.Rollback();
                return "0";
            }
            Tranx.Commit();

            //StringBuilder sb = new StringBuilder();
            //sb = new StringBuilder();
            //sb.Append(" SELECT CAST(CONCAT(IFNULL(om.ObservationType_ID,''),'$',IFNULL(om.Name,''),'$',IFNULL(im.Name,''),'$',IFNULL(im.Type,''),'$',  ");
            //sb.Append(" IFNULL(im.ReportType,''),'$',IFNULL(im.Print_Sequence,''),'$',IFNULL(im.Investigation_Id,''),'$',IFNULL(io.Investigation_ObservationType_ID,''),'$',IFNULL(it.ItemID,''),'$',IFNULL(im.Description,''),'$',IFNULL(im.principle,''),'$',IFNULL(it.IsTrigger,''),'$', ");
            //sb.Append(" IFNULL(im.SampleQty,''),'$',IFNULL(im.printHeader,''),'$',IFNULL(im.GenderInvestigate,''),'$',IFNULL(im.SampleTypeID,''),'$',IFNULL(it.ItemCode,''),'$',IFNULL(it.IsActive,''),'$',im.IsOutSource,'$',it.RateEditable,'$',im.IsUrgent,'$',im.PrintHeader,'$', ");
            //sb.Append(" im.ShowOnline,'$',im.PrintSeperate,'$',im.PrintSampleName,'$',IFNULL((select Name from Type_Master where ID=it.DeptID AND TypeID=5),''),'$',it.IsDiscountable,'$',it.DeptID,'$',im.IsCulture,'$',im.SampleContainer,'|',1)  ");
            //sb.Append(" AS CHAR) newValue FROM observationtype_master om  ");
            //sb.Append(" INNER JOIN investigation_observationtype io ON om.ObservationType_ID = io.ObservationType_Id   "); 
            //sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id = io.Investigation_ID   ");
            //sb.Append(" AND im.Name<>'' ");
            //sb.Append(" INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID ");
            //sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID  INNER JOIN f_categoryrole cr ON cr.ObservationType_ID =io.ObservationType_Id    ");
            //sb.Append(" INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigID=3  and cr.RoleID='" + HttpContext.Current.Session["RoleID"] + "' ");
            //sb.Append(" ORDER BY im.ID Desc limit 1 ");
            //value=  StockReports.ExecuteScalar(sb.ToString());
            
           // value = DepartmentID + "$" + DepartmentName + "$" + InvName + "$" + SampleType + "$" + ReportType + "$" + (maxprintseq + 1) + "$" + Investigation_ID + "$" + InvObsId + "$" + ItemId + "$" + Gender + "$" + sampletypename + "$" + CPTCode + "|1";
                       
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            return ex.Message;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public string UpdateInvestigation(string InvName, string Description, string InvID, string ItemID, string DepartmentID, string InvObsId, string DepartmentName, string ReportType, string SampleType, string PrintSequence, string Gender, string Principle, string sampletypename, string CPTCode, int Active, int outsource, int RateEditable, int IsUrgent, int ShowPtRpt, int ShowOnlineRpt, int PrintSeperate, int PrintSampleName, int DeptID, int IsDiscountable, string SampleTypeID, string IsCulture, string SampleContainer)
    {
        LoadCacheQuery.dropCache("OPDDiagnosisItems");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (SampleType == "N")
                sampletypename = "";
            if (PrintSequence == "")
                PrintSequence = "0";
            StringBuilder str = new StringBuilder();
            str.Append(" Update Investigation_master Set Name ='" + InvName + "',");
            str.Append(" Description ='" + Description + "',");
            str.Append(" ReportType =" + ReportType + ",");
            str.Append(" Type ='" + SampleType + "',");    
            str.Append(" GenderInvestigate='" + Gender + "', ");
            str.Append(" Print_Sequence='" + PrintSequence  + "',");
            str.Append(" Principle='" + Principle + "',");
            str.Append(" sampleTypename='" + sampletypename + "',IsOutSource=" + outsource + ",  ");
            str.Append(" IsUrgent=" + IsUrgent + ",PrintHeader=" + ShowPtRpt + " ,ShowOnline=" + ShowOnlineRpt + " ,");
            str.Append(" PrintSeperate=" + PrintSeperate + ",PrintSampleName=" + PrintSampleName + ", ");
            str.Append(" SampleTypeID='" + SampleTypeID + "', ");
            str.Append(" IsCulture=" + IsCulture + ",SampleContainer=" + SampleContainer + " ");
            str.Append(" Where Investigation_ID ='" + InvID + "'");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString());

            str = new StringBuilder();
            str.Append(" Update Investigation_observationtype Set ");
            str.Append(" Investigation_ID ='" + Util.GetString(InvID) + "',");
            str.Append(" ObservationType_Id ='" + DepartmentID + "'");
            str.Append(" Where Investigation_ObservationType_ID ='" + InvObsId + "'");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString());

            string SubCategoryID = Util.GetString( MySqlHelper.ExecuteScalar(con,CommandType.Text, "Select sc.SubCategoryID from f_subcategorymaster sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID where cf.ConfigID=3 and sc.Name='" + DepartmentName + "'"));

            if (SubCategoryID != "")
            {
                str = new StringBuilder();
                str.Append(" Update f_Itemmaster Set TypeName ='" + InvName + "',");
                str.Append(" SubCategoryID ='" + Util.GetString(SubCategoryID) + "', ");
                str.Append(" ItemCode='" + CPTCode + "',IsActive=" + Active + ",RateEditable=" + RateEditable + ",DeptID=" + DeptID + ",IsDiscountable=" + IsDiscountable + " ");
                str.Append(" Where ItemID ='" + ItemID + "'");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString());

            }
            else
            {
                Tranx.Rollback();
                return "0";
            }

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }       
    }

    public DataTable GetObservation_Details(string ObservationID, string InvestigationID, string Gender, string MachineID, string CentreID)
    {
        string str = "Select ID,FromAge,ToAge,(ifnull(ToAge,0)/365)ToAgeyears,MinReading,MaxReading,MinCritical,MaxCritical,ReadingFormat,DisplayReading,DefaultReading,Gender,ConversionFactor,ConversionFactorUnit from labobservation_range where  LabObservation_ID='" + ObservationID + "' and Gender='" + Gender + "' AND MachineID='" + MachineID + "' AND CentreID=" + CentreID + " ";
        DataTable dt = StockReports.GetDataTable(str);
        return dt;
    }

    public string ObservationExists(string ObservationName, string ObservationID)
    {
        try
        {
            int str = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) from labobservation_master where name='" + ObservationName + "'and Labobservation_id !='" + ObservationID + "'").ToString());
            return str.ToString();
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "";
        }
    }
    public DataTable GetObs_MasterData(string ObservationID)
    {
        string str = "Select Name,Culture_flag,Suffix from labobservation_master where  LabObservation_ID='" + ObservationID + "' ";
        DataTable dt = StockReports.GetDataTable(str);
        return dt;
    }

    public string updtObsRangesForAllInv(string ObservationName, string ObservationID, string ObsRangeData, string Gender, string Suffix, string IsCulture)
    {
        ObservationName = ObservationName.Trim();
        ObservationID = ObservationID.Trim();
        ObsRangeData = ObsRangeData.Trim();
        Gender = Gender.Trim();
        Suffix = Suffix.Trim();
        IsCulture = IsCulture.Trim();
        //ObsRangeData=FromAge|ToAge|MinReading|MaxReading|MinCritical|MaxCritical|ReadingFormat#

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        DataTable dt = new DataTable();
        try
        {
            string updtObs = "Update labobservation_master set Name='" + ObservationName + "',Suffix='" + Suffix.Trim() + "',Culture_flag='" + Util.GetInt(IsCulture) + "' where LabObservation_ID='" + ObservationID + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, updtObs);

            string strdlt = "Delete From labobservation_range where LabObservation_ID='" + ObservationID + "' and Gender='" + Gender + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strdlt);
            ObsRangeData = ObsRangeData.TrimEnd('#');
            int len = Util.GetInt(ObsRangeData.Split('#').Length);
            string[] Obs = new string[len];
            Obs = ObsRangeData.Split('#');
            string str = "select Investigation_Id from labobservation_investigation where labObservation_ID='" + ObservationID.Trim() + "'";
            dt = MySqlHelper.ExecuteDataset(con,CommandType.Text,str).Tables[0];
            if (dt != null && dt.Rows.Count > 0)
            {
                if (ObsRangeData != "")
                {

                    for (int j = 0; j < dt.Rows.Count; j++)
                    {
                        for (int i = 0; i < len; i++)
                        {
                            LabObservation_Range obj = new LabObservation_Range(Tranx);
                            obj.LabObservation_ID = ObservationID.Trim();
                            obj.Investigation_ID = dt.Rows[j]["Investigation_Id"].ToString().Trim();
                            obj.FromAge = Util.GetDecimal(Obs[i].Split('|')[0]);
                            obj.ToAge = Util.GetDecimal(Obs[i].Split('|')[1]);
                            obj.Gender = Gender.Trim();
                            obj.MinReading = Util.GetString(Obs[i].Split('|')[2]).Trim();
                            obj.maxReading = Util.GetString(Obs[i].Split('|')[3]).Trim();
                            obj.MinCritical = Util.GetDecimal(Obs[i].Split('|')[4]);
                            obj.MaxCritical = Util.GetDecimal(Obs[i].Split('|')[5]);
                            obj.ReadingFormat = Util.GetString(Obs[i].Split('|')[6]).Trim();
                            obj.DisplayReading = Util.GetString(Obs[i].Split('|')[7]).Trim();
                            obj.DefaultReading = Util.GetString(Obs[i].Split('|')[8]).Trim();
                            obj.UserID = HttpContext.Current.Session["ID"].ToString();
                            obj.Entdatetime = DateTime.Now;
                            obj.UpdateID = HttpContext.Current.Session["ID"].ToString();
                            obj.UpdateName = HttpContext.Current.Session["LoginName"].ToString();
                            obj.UpdateRemarks = "";
                            obj.updateDate = DateTime.Now;
                            obj.Insert();


                        }

                    }
                }
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string updtObsRanges(string ObservationName, string ObservationID, string InvestigationID, string ObsRangeData, string Gender, string Suffix, string IsCulture, string MachineID, string CentreID, string AllCentre)
    {
        //ObsRangeData=FromAge|ToAge|MinReading|MaxReading|MinCritical|MaxCritical|ReadingFormat|DisplayReading|DefaultReading#

        ObservationName = ObservationName.Trim();
        ObservationID = ObservationID.Trim();
        InvestigationID = InvestigationID.Trim();
        ObsRangeData = ObsRangeData.Trim();
        Gender = Gender.Trim();
        //ShortName=ShortName.Trim();
        Suffix = Suffix.Trim();
        //AnylRpt=AnylRpt.Trim();
        IsCulture = IsCulture.Trim();


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string updtObs = "Update labobservation_master set Name='" + ObservationName + "',Suffix='" + Suffix.Trim() + "',Culture_flag='" + Util.GetInt(IsCulture) + "' where LabObservation_ID='" + ObservationID + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, updtObs);
            string str = "Delete From labobservation_range where LabObservation_ID='" + ObservationID + "' and Gender='" + Gender + "' AND MachineID='" + MachineID + "'  ";
            if (AllCentre == "0")
            {
                str += " and CentreID = '" + CentreID + "' ";
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            ObsRangeData = ObsRangeData.TrimEnd('#');
            int len = Util.GetInt(ObsRangeData.Split('#').Length);
            string[] Obs = new string[len];
            Obs = ObsRangeData.Split('#');
            if (ObsRangeData != "")
            {
                for (int i = 0; i < len; i++)
                {
                    LabObservation_Range obj = new LabObservation_Range(Tranx);
                    obj.LabObservation_ID = ObservationID.Trim();
                    obj.Investigation_ID = "";
                    obj.FromAge = Util.GetDecimal(Obs[i].Split('|')[0]);
                    obj.ToAge = Util.GetDecimal(Obs[i].Split('|')[1]);
                    obj.Gender = Gender.Trim();
                    obj.MinReading = Util.GetString(Obs[i].Split('|')[2]).Trim();
                    obj.maxReading = Util.GetString(Obs[i].Split('|')[3]).Trim();
                    obj.MinCritical = Util.GetDecimal(Obs[i].Split('|')[4]);
                    obj.MaxCritical = Util.GetDecimal(Obs[i].Split('|')[5]);
                    obj.ReadingFormat = Util.GetString(Obs[i].Split('|')[6]).Trim();
                    obj.DisplayReading = Util.GetString(Obs[i].Split('|')[7]).Trim();
                    obj.DefaultReading = Util.GetString(Obs[i].Split('|')[8]).Trim();
                    obj.UserID = HttpContext.Current.Session["ID"].ToString();
                    obj.Entdatetime = DateTime.Now;
                    obj.UpdateID = HttpContext.Current.Session["ID"].ToString();
                    obj.UpdateName = HttpContext.Current.Session["LoginName"].ToString();
                    obj.UpdateRemarks = "";
                    obj.updateDate = DateTime.Now;
                    obj.ConversionFactor = Util.GetString(Obs[i].Split('|')[9]).Trim();
                    obj.ConversionFactorUnit = Util.GetString(Obs[i].Split('|')[10]).Trim();
                    obj.MachineID = MachineID;
                    obj.CentreID = Util.GetInt(CentreID);
                    obj.Insert();
                }
            }
            if (AllCentre == "1")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO labobservation_range(Investigation_ID,LabObservation_ID,Gender,FromAge,ToAge,MinReading,MaxReading,");
                sb.Append(" DisplayReading,DefaultReading,MinCritical,MaxCritical,ReadingFormat,UserID,EntDateTime,UpdateID,");
                sb.Append(" UpdateName,UpdateRemarks,Updatedate,ConversionFactor,ConversionFactorUnit,MachineID) ");

                sb.Append(" SELECT lr.Investigation_ID,lr.LabObservation_ID,lr.Gender,lr.FromAge,lr.ToAge,lr.MinReading,lr.MaxReading,  ");
                sb.Append(" lr.DisplayReading,lr.DefaultReading,lr.MinCritical,lr.MaxCritical,lr.ReadingFormat,lr.UserID,lr.EntDateTime,lr.UpdateID,");
                sb.Append(" lr.UpdateName,lr.UpdateRemarks,lr.Updatedate,ConversionFactor,ConversionFactorUnit,MachineID ");
                sb.Append(" FROM labobservation_range lr ");
                sb.Append(" CROSS JOIN center_master cm  ");
                sb.Append(" WHERE cm.isActive=1  AND lr.centreid=" + CentreID + " AND cm.centreid!=" + CentreID + " and lr.LabObservation_ID='" + ObservationID.Trim() + "' ");
                sb.Append(" and lr.MachineID='" + MachineID + "'  ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    public string SaveNewObservation(string ObsName, string Suffix)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string value = "";
        try
        {

            int Obscount = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from labobservation_master where name='" + ObsName.Trim() + "'").ToString());
            if (Obscount > 0)
            {
                Tranx.Rollback();                
                return "0";
            }

            string Observation_Id = "";
            Labobservation_master objLabobservation_master = new Labobservation_master();
            objLabobservation_master.Creator_ID = HttpContext.Current.Session["ID"].ToString();
            objLabobservation_master.Name = ObsName;
            objLabobservation_master.Suffix = Suffix;
            Observation_Id = objLabobservation_master.Insert();
            value = ObsName + "$" + Suffix;
            Tranx.Commit();
            return Observation_Id;
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "1";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable Get_InvPriorty(string SubCategoryId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT inv.Name,inv.Investigation_Id as ID,inv.Print_Sequence,im.SubCategoryID ");
        sb.Append(" FROM f_itemmaster im ");
        sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id = im.Type_ID ");
        sb.Append(" AND im.IsActive=1 AND im.SubCategoryID='" + SubCategoryId + "' ");
        sb.Append(" ORDER BY  inv.Print_Sequence ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    public DataTable Get_DeptPriorty()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sc.Name, CONCAT(sc.SubcategoryID,'#',om.ObservationType_ID)ID ");
        sb.Append(" FROM f_subcategorymaster sc INNER JOIN ");
        sb.Append(" f_configrelation c ON c.CategoryID=sc.CategoryID AND c.ConfigID='3'");
        sb.Append(" INNER JOIN observationtype_master om ON om.Description=sc.SubcategoryID ");
        sb.Append(" ORDER BY om.Print_Sequence ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public string SaveInvOrdering(string InvOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            // ObsData= Order|ObservationId|Header|IsCritical#
            InvOrder = InvOrder.TrimEnd('|');

            string str = "";
            int len = Util.GetInt(InvOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = InvOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                str = " UPDATE f_itemmaster im INNER JOIN investigation_master inv ON inv.Investigation_Id=im.Type_Id" +
                     " INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID" +
                     " INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID AND c.ConfigID='3'" +
                     " SET im.ShowFlag='" + (Util.GetInt(i) + 1) + "', inv.Print_Sequence='" + (Util.GetInt(i) + 1) + "' WHERE inv.Investigation_Id='" + Data[i].ToString() + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public string SaveDeptOrdering(string DeptOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            DeptOrder = DeptOrder.TrimEnd('|');
            string str = "";
            int len = Util.GetInt(DeptOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = DeptOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                str = "Update observationtype_master set Print_Sequence='" + (Util.GetInt(i) + 1) + "' where ObservationType_ID='" + Data[i].Split('#')[1] + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public DataTable Get_NablInvestigations(string CentreId, string SubCategoryId)
    {
        DataTable dt = new DataTable();

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT io.ObservationType_ID SubCategoryID,om.Name AS DeptName,im.Investigation_Id Type_ID,im.Name AS InvName,IFNULL(id.isNABL,0)isNABL ");

        sb.Append(" FROM investigation_master im INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 ");
        sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master om ON om.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID ");
        if (SubCategoryId.ToUpper() != "ALL")
            sb.Append(" AND cr.`ObservationType_ID`='" + SubCategoryId + "' ");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT * FROM `investiagtion_isNABL` WHERE  `CentreID`='" + CentreId + "' ");
        if (SubCategoryId.ToUpper() != "ALL")
            sb.Append(" AND `SubCategoryID`='" + SubCategoryId + "' ");
        sb.Append(" ) id ");
        sb.Append(" ON id.Investigation_id=im.Investigation_Id AND id.SubCategoryID=io.ObservationType_ID WHERE it.IsActive=1 GROUP BY im.Investigation_Id");

        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public string Save_isNABLInv(string CentreId, string SubCategoryId, string ItemData)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // Itemdata= 0)SubCategoryID|1)InvID|2)isNABL
            ItemData = ItemData.TrimEnd('#');

            string str = string.Empty;
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            for (int i = 0; i < len; i++)
            {
                SubCategoryId = Util.GetString(Item[i].Split('|')[0]).Split('#')[0];
                str = "Delete from investiagtion_isnabl where CentreID='" + CentreId + "' and SubcategoryID='" + SubCategoryId + "' and Investigation_ID='" + Util.GetString(Item[i].Split('|')[1]) + "'";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                string strins = " Insert into investiagtion_isnabl (`CentreID`,`SubcategoryID`, `Investigation_ID`,isNABL,UpdatedBy) " +
                       " values ('" + CentreId + "','" + SubCategoryId + "','" + Util.GetString(Item[i].Split('|')[1]) + "','" + Util.GetInt(Item[i].Split('|')[2]) + "','"+ HttpContext.Current.Session["ID"].ToString() +"') ";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strins);
            }

            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public DataTable getTestCentre(string BookingCentre, string Department, string TestName)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT im.Investigation_Id  Type_ID,im.Name AS TypeName,IF(IFNULL(tcm.`Test_Centre`,0)=0,'1','0')TestCentre1,IF(IFNULL(tcm.`Test_Centre2`,0)=0,'1','0')TestCentre2,IF(IFNULL(tcm.`Test_Centre3`,0)=0,'1','0')TestCentre3,IFNULL(tcm.`Test_Centre`,'" + BookingCentre + "') Test_Centre,IFNULL(tcm.`Test_Centre2`,'" + BookingCentre + "') Test_Centre2,IFNULL(tcm.`Test_Centre3`,'" + BookingCentre + "') Test_Centre3 ");
        sb.Append(" FROM investigation_master im INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 ");
        sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
        if (Department != "")
            sb.Append(" and  iom.ObservationType_Id='" + Department + "' ");

        if (TestName != "")
            sb.Append(" and  im.Name like '" + TestName + "%' ");
        sb.Append(" LEFT JOIN `test_centre_mapping` tcm ON tcm.`Booking_Centre`='" + BookingCentre + "'  AND im.`Investigation_Id`=tcm.`Investigation_ID`  ");
        sb.Append(" GROUP By im.Investigation_ID ORDER BY im.`Name`  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public string SaveTestCentre(string BookingCentre, string Investigation_ID, string TestCentre, string TestCentre1, string TestCentre2)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from test_centre_mapping where Booking_Centre='" + BookingCentre + "' and Investigation_ID='" + Investigation_ID + "'");
            string qstr = "insert into test_centre_mapping(Booking_Centre,Test_Centre,Test_Centre2,Test_Centre3,Investigation_ID,UserID,Username) " +
                     "values('" + BookingCentre + "','" + TestCentre + "','" + TestCentre1 + "','" + TestCentre2 + "','" + Investigation_ID + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "')";

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, qstr);
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}
