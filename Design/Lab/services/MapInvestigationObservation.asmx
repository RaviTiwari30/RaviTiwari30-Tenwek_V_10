<%@ WebService Language="C#" Class="MapInvestigationObservation" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class MapInvestigationObservation : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public string GetObservation(string InvestigationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt = ObjMapInvObs.Get_Observation(InvestigationID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string Formula(string labobservation_id, string formulaText, string Name)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.getFormula(labobservation_id, formulaText, Name);
    }
    [WebMethod(EnableSession = true)]
    public string DeleteFormula(string labobservation_id)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.DelFormula(labobservation_id);

    }
    [WebMethod(EnableSession = true)]
    public string BindInvestigation()
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt = ObjMapInvObs.Bind_Investigation();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string BindListBox(string Dept)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt = ObjMapInvObs.BindInvListBox(Dept);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string GetObservationData(string InvestigationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt = ObjMapInvObs.GetObservation_Data(InvestigationID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string cptcode(string CPTCode)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.cptcode(CPTCode);
    }
    [WebMethod(EnableSession = true)]
    public string SaveMapping(string InvestigationID, string Order)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveMapping(InvestigationID, Order);
    }

    [WebMethod(EnableSession = true)]
    public string SaveObservation(string InvestigationID, string ObservationId)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveObservation(InvestigationID, ObservationId);

    }
    [WebMethod(EnableSession = true)]
    public string RemoveObservation(string InvestigationID, string ObservationId)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.RemoveObservation(InvestigationID, ObservationId);
    }
    [WebMethod(EnableSession = true)]
    public string SaveNewInvestigation(string InvName, string Description, string DepartmentID, string DepartmentName, string ReportType, string SampleType, string PrintSequence, string Gender, string Principle, string sampletypename, string CPTCode, string outsource, int RateEditable, int IsUrgent, int ShowPtRpt, int ShowOnlineRpt, int PrintSeperate, int PrintSampleName, int DeptID, int IsDiscountable, string SampleTypeID, string IsCulture, string SampleContainer)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveNewInvestigation(InvName, Description, DepartmentID, DepartmentName, ReportType, SampleType, PrintSequence, Gender, Principle, sampletypename, CPTCode, outsource, RateEditable, IsUrgent, ShowPtRpt, ShowOnlineRpt, PrintSeperate, PrintSampleName, DeptID, IsDiscountable, SampleTypeID,IsCulture,SampleContainer);

    }
    [WebMethod(EnableSession = true)]
    public string UpdateInvestigation(string InvName, string Description, string InvID, string ItemID, string DepartmentID, string InvObsId, string DepartmentName, string ReportType, string SampleType, string PrintSequence, string Gender, string Principle, string sampletypename, string CPTCode, int Active, int outsource, int RateEditable, int IsUrgent, int ShowPtRpt, int ShowOnlineRpt, int PrintSeperate, int PrintSampleName, int DeptID, int IsDiscountable, string SampleTypeID, string IsCulture, string SampleContainer)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.UpdateInvestigation(InvName, Description, InvID, ItemID, DepartmentID, InvObsId, DepartmentName, ReportType, SampleType, PrintSequence, Gender, Principle, sampletypename, CPTCode, Active, outsource, RateEditable, IsUrgent, ShowPtRpt, ShowOnlineRpt, PrintSeperate, PrintSampleName, DeptID, IsDiscountable, SampleTypeID, IsCulture, SampleContainer);

    }
    [WebMethod(EnableSession = true)]
    public string GetObservationDetails(string ObservationID, string InvestigationID, string Gender, string MachineID, string CentreID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt = ObjMapInvObs.GetObservation_Details(ObservationID, InvestigationID, Gender, MachineID, CentreID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string GetObsMasterData(string ObservationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt = ObjMapInvObs.GetObs_MasterData(ObservationID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string ObservationExists(string ObservationName, string ObservationID)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.ObservationExists(ObservationName, ObservationID);

    }
    [WebMethod(EnableSession = true)]
    public string updtObsRangesForAllInv(string ObservationName, string ObservationID, string InvestigationID, string ObsRangeData, string Gender, string Suffix, string IsCulture)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.updtObsRangesForAllInv(ObservationName, ObservationID, ObsRangeData, Gender, Suffix, IsCulture);

    }

    [WebMethod(EnableSession = true)]
    public string updtObsRanges(string ObservationName, string ObservationID, string InvestigationID, string ObsRangeData, string Gender, string Suffix, string IsCulture, string MachineID, string CentreID, string AllCentre)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.updtObsRanges(ObservationName, ObservationID, InvestigationID, ObsRangeData, Gender, Suffix, IsCulture, MachineID, CentreID, AllCentre);

    }
    [WebMethod(EnableSession = true)]
    public string SaveNewObservation(string ObsName, string Suffix)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveNewObservation(ObsName, Suffix);
    }
    [WebMethod(EnableSession = true)]
    public string SaveInvOrdering(string InvOrder)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveInvOrdering(InvOrder);

    }
    [WebMethod(EnableSession = true)]
    public string GetInvPriorty(string SubCategoryId)
    {
        DataTable dt = new DataTable();
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        dt = ObjMapInvObs.Get_InvPriorty(SubCategoryId.Split('#')[0].Trim());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string GetDeptPriorty()
    {
        DataTable dt = new DataTable();
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        dt = ObjMapInvObs.Get_DeptPriorty();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string SaveDeptOrdering(string DeptOrder)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveDeptOrdering(DeptOrder);
    }
    [WebMethod(EnableSession = true)]
    public string SelectGender(string InvestigationID)
    {
        return StockReports.ExecuteScalar("Select  GenderInvestigate from investigation_master where Investigation_ID='" + InvestigationID + "'");
    }
    [WebMethod]
    public string SampleType()
    {
        string sql = " Select ID,SampleType from sample_type where IsActive=1 ORDER BY sampletype ";

        DataTable dt = StockReports.GetDataTable(sql.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string changecolor(string LedgerTransactionNo, string LoginType)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Result_Flag FROM patient_labinvestigation_ipd where LedgerTransactionNo=lshhi'" + LedgerTransactionNo + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public string UpdateSerial(string SerialNo, string LedgerTransactionNo, string LabType)
    {
        string strQuery = string.Empty;
        //if (LabType == "IPD")
        //    strQuery = "update patient_labinvestigation_ipd  set SerialNo='" + SerialNo + "' where LedgerTransactionNo='" + LedgerTransactionNo + "'";
        //else
            strQuery = "update patient_labinvestigation_opd  set SerialNo='" + SerialNo + "' where LedgerTransactionNo='" + LedgerTransactionNo + "'";
        StockReports.ExecuteDML(strQuery);
        return "1";
    }
    //Only For OPD Patient
    [WebMethod(EnableSession = true)]
    public string ViewLabOPD(string IPDNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT TIME_FORMAT(TIME,'%h:%i:%p') AS TIME,DATE_FORMAT(DATE,'%d-%b-%Y') AS DATE,SampleDate,");
        sb.Append(" plo.TransactionID,");
        sb.Append(" IFNULL((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=plo.ID  order by PLO_ID desc limit 1),'')LabInves_Description,");
        sb.Append(" im.Name,im.ReportType,");
        sb.Append(" OM.Name Department ");
        sb.Append(" FROM patient_labinvestigation_opd plo ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_ID=plo.Investigation_Id");
        sb.Append(" INNER JOIN investigation_observationtype IO ON IM.Investigation_Id = IO.Investigation_ID ");
        sb.Append(" INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id");
        sb.Append(" WHERE result_flag is not null");
        sb.Append(" AND plo.IPNo ='" + IPDNo + "' ");
        sb.Append(" Order By plo.Date DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else

            return "";

    }

    // funtion to get Labobservation Comments list
    [WebMethod(EnableSession = true)]
    public string CommentsLabObservation(string LabObservation_ID)
    {
        string str = "SELECT Comments_ID,Comments_Head FROM labobservation_comments WHERE LabObservation_ID='" + LabObservation_ID + "' ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else

            return "";
    }


    // funtion to get Labobservation Comments list
    [WebMethod(EnableSession = true)]
    public string GetCommentslabobservation(string CmntID)
    {
        return StockReports.ExecuteScalar("SELECT comments FROM labobservation_comments WHERE Comments_ID='" + CmntID + "' ");

    }
    [WebMethod(EnableSession = true)]
    public string SearchMail(string LabNo, string MRNo, string PName, string CentreID, string FromDate, string ToDate, string Dept, string Status, string ContactNo, string ReferBy, string Ptype, string FromLabNo, string ToLabNo, string PanelID, string InputType)
    {

        MailStatus objmail = new MailStatus();
        DataTable dt = objmail.Search_Mail(LabNo, MRNo, PName, CentreID, FromDate, ToDate, Dept, Status, ContactNo, ReferBy, Ptype, FromLabNo, ToLabNo, PanelID, InputType);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true)]
    public string SendMail(string PanelID, string TestID, string PHead, string LoginType)
    {
        MailStatus objmail = new MailStatus();
        return objmail.SendMail(PanelID, TestID, PHead, LoginType);    
    }
    [WebMethod(EnableSession = true)]
    public string GetNablInvestigations(string CentreId, string SubCategoryId)
    {
        DataTable dt = new DataTable();
        MapInvestigation_Observation objitem = new MapInvestigation_Observation();
        dt = objitem.Get_NablInvestigations(CentreId, SubCategoryId.Split('#')[0].Trim());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string Save_isNABLInv(string CentreId, string SubCategoryId, string ItemData)
    {
        MapInvestigation_Observation objitem = new MapInvestigation_Observation();
        return objitem.Save_isNABLInv(CentreId, SubCategoryId, ItemData);
    }
    [WebMethod(EnableSession = true)]
    public string getTestCentre(string BookingCentre, string Department, string TestName)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return Newtonsoft.Json.JsonConvert.SerializeObject(ObjMapInvObs.getTestCentre(BookingCentre, Department, TestName));
    }
    [WebMethod(EnableSession = true)]
    public string SaveTestCentre(string BookingCentre, string Investigation_ID, string TestCentre, string TestCentre1, string TestCentre2)
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        return ObjMapInvObs.SaveTestCentre(BookingCentre, Investigation_ID, TestCentre, TestCentre1, TestCentre2);
    }
}

