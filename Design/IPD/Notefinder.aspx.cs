using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Serialization;

public partial class Design_IPD_Notefinder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");

    }

    [WebMethod(EnableSession = true)]
    public static string notefindersearch(string cadreID, string tierID, string specialtyID, string noteType, string encounter, string encounterType,string fromdate,string todate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT t.* FROM ( ");
        // Requirement came that the same user (who enters the notes) should not be able to Acknowledge the same. So, Below condition putted.
        sb.Append(" SELECT IF(ptw.IsView=0,IF(ptw.UserID='" + HttpContext.Current.Session["ID"].ToString() + "',1,0),ptw.IsView)IsView, ");
        // sb.Append(" SELECT  ptw.IsView, ");
        sb.Append("  ptw.`IsApproved`,IF(ptw.`IsApproved`=1,'Approved','Not Approved')ApprovedStatus, ifnull( DATE_FORMAT(ptw.`ApprovedDate`,'%d-%b-%Y %I:%i %p'),'')ApprovedDate, ");
        sb.Append(" ifnull( ptw.`ApprovedRemark`,'') ApprovedRemark,ifnull((SELECT CONCAT(title,' ',NAME) FROM employee_master WHERE EmployeeID=ptw.`ApprovedBy`),'')ApprovedBy, ");
        sb.Append(" if(ptw.IsView=1, CONCAT('Acknowledge By ',ptw.ViewByName,' on ',DATE_FORMAT(ptw.ViewDateTime,'%d-%b-%Y %r')),'') Ackstring,ptw.ID as PatientDetailID,IF(IFNULL(TIMESTAMPDIFF(MINUTE,EntryDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0')Isedit,  0 as Notetypecreation,ptw.TransactionID,ptw.PatientID,CONCAT(DATE_FORMAT(ptw.EntryDate,'%d-%b-%Y'),' ',TIME_FORMAT(ptw.EntryDate,'%h:%i:%s %p'))Dates, ptw.EntryDate AS CreateDate,ntm.HeaderName NoteType, ");
        sb.Append(" (SELECT CONCAT(title,' ',NAME) FROM employee_master WHERE EmployeeID=ptw.UserID)Author,ptw.Cadre,ptw.Tier,ptw.Specialty,ptw.Detail,ptw.ID,ptw.CadreID,ptw.TierID,ptw.SpecialtyID,1 Active,ptw.Header_Id  notetypevalue,IFNULL(rm.RoleName,'')RoleName  FROM notecreationpatient_detail ptw   inner join NoteTypeMaster ntm on ntm.Header_Id=ptw.Header_Id Left Join f_rolemaster rm on rm.DeptLedgerNo=ptw.NoteCreateDeptLedgerNo");
        if (encounter == "1")
        {
            sb.Append(" where  ptw.PatientID='" + encounterType + "'");

        }
        else
        {
            sb.Append(" where ptw.TransactionID='" + encounterType + "'");
            
        }
        sb.Append(" ORDER BY ptw.ID DESC ");//group by ptw.Header_Id,ptw.UserID 
         sb.Append(" )t where t.Active=1 ");

       if (encounter == "1")
       {
           sb.Append(" and t.PatientID='" + encounterType + "'");

       }
       else if (encounter == "2") { sb.Append(" and  t.TransactionID='" + encounterType + "' and t.CreateDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "'and t.CreateDate>='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "'"); }
       else if (encounter == "0") { sb.Append(" and  t.TransactionID='" + encounterType + "'"); }
       if (cadreID != "0") { sb.Append(" and t.CadreID='" + cadreID + "'"); }
       if (tierID != "0") { sb.Append(" and  t.TierID='" + tierID + "'"); }
       if (specialtyID != "0") { sb.Append(" and t.SpecialtyID='" + specialtyID + "'"); }
       if (noteType != "0") { sb.Append(" and t.notetypevalue='" + noteType + "'"); }



       DataTable dt = StockReports.GetDataTable(sb.ToString());
       if (dt.Rows.Count > 0)
       {
           return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
       }
    
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); } 

    }
    [WebMethod(EnableSession = true)]
    public static string bindnotecreationdetails(string encounterType, string encounter, string NoteTypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select id,NoteType,Problem,OnSet,Description,Code,Surgery,ifnull(ifnull(DATE_FORMAT(SurgeryDate,'%d-%b-%Y'),''),'')SurgeryDate,Illness,RelationShip,Issue,DoctorID,PatientID,TransactionID,Createdby,date_format(CreatedDate,'%d-%b-%Y')CreatedDate,(select Concat(Title,' ',Name) from employee_master em where EmployeeID=Createdby)Author from PatientNoteCreation  where ID='" + NoteTypeID + "' and Active=1 ");
        if (encounter == "0")
        {
            sb.Append(" and TransactionID='" + encounterType + "'");
        }
        else { sb.Append(" and PatientID='" + encounterType + "'"); }
     

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }

        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }

    }
    [WebMethod(EnableSession = true, Description = "Save Patient Note Creation")]

    public static string UpdateNoteCreationpatientlist(object NoteCreation,string NotefinderTypeID)
    {

        List<NoteCreation> dataPNC = new JavaScriptSerializer().ConvertToType<List<NoteCreation>>(NoteCreation);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var message="";
        if (dataPNC[0].SurgeryDate == "")
        {
            dataPNC[0].SurgeryDate = "0001-00-00 00:00:00";
        }
        else { dataPNC[0].SurgeryDate = Util.GetDateTime(dataPNC[0].SurgeryDate).ToString("yyyy-MM-dd"); }
                try
                {
                    var sqlCMD = "update PatientNoteCreation pn set pn.Problem=@Problem,pn.OnSet=@OnSet,pn.Description=@Description,pn.Code=@Code,pn.Surgery=@Surgery,pn.SurgeryDate=@SurgeryDate,pn.Illness=@Illness,pn.RelationShip=@RelationShip,pn.Issue=@Issue,pn.UpdateDate=now(),pn.Updateby=@Updateby where pn.ID=@ID;";
                  excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                  {
                
                      Problem = dataPNC[0].Problem,
                      OnSet = dataPNC[0].OnSet,
                      Description = dataPNC[0].Description,
                      Code = dataPNC[0].Code,
                      Surgery = dataPNC[0].Surgery,
                      SurgeryDate=dataPNC[0].SurgeryDate,
                      Illness = dataPNC[0].Illness,
                      RelationShip = dataPNC[0].RelationShip,
                      Issue = dataPNC[0].Issue,
                      Updateby = HttpContext.Current.Session["ID"].ToString(),
                      ID = Util.GetInt(dataPNC[0].ID)
                  });
                            message = "Record Update Sucessfully";
                            tnx.Commit();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
            }


                   catch (Exception ex)
                {
                    tnx.Rollback();
                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
    }
    [WebMethod(EnableSession = true)]
    public static string bindPatientnotewritedata(string encounterType, string encounter, string NoteTypeID, string notetypevalue)
    {

    
     
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT ifnull(pt.Detail,'')Detail,ID FROM notecreationpatient_detail pt WHERE pt.ID='" + NoteTypeID + "'  ");//and pt.UserID='" + HttpContext.Current.Session["ID"].ToString() + "'


        if (dt.Rows.Count > 0)
        {
             
           
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }

    [WebMethod(EnableSession = true)]
    public static string BindPatientNoteCreation(string NoteTypevalue, string TID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        if (NoteTypevalue == "DM")
        {
            dt = StockReports.GetDataTable(" select dm.Medicinename as DrugName,dm.Time_next_Dose as NextDose,dm.Dose as Dose,dm.Days as Duration,dm.Meal  from discharge_medicine dm where TransactionID='" + TID + "'");
        }

        if (NoteTypevalue == "FD")
        {
            dt = StockReports.GetDataTable(" SELECT icd.Group_Desc AS Diagnosis,icd.ICD10_3_Code AS DiagnosisCode FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.TransactionID='" + TID + "'");
        }
        else if (NoteTypevalue == "Allergy")
        {
            dt = StockReports.GetDataTable(" select IFNULL(Allergies,'')Allergies from cpoe_hpexam dm  where TransactionID='" + TID + "'");
        }
        else if (NoteTypevalue == "Vital")
        {
            dt = StockReports.GetDataTable("SELECT concat('<b>Vital- </b> ','Weight: ',ipo.Weight,' Height ',ipo.Height,' BP: ',ipo.Bp,' Temp: ',ipo.Temp,' RR: ',ipo.Resp,' SPO2: ',ipo.Oxygen)Vitals FROM IPD_Patient_ObservationChart ipo where ipo.TransactionID='" + TID + "' order by id desc limit 1");
        }
        else if (NoteTypevalue == "Lab")
        {
            sb.Append("   SELECT concat('<b>Lab- </b>',IFNULL(CONCAT(( SELECT  (CONCAT('HB',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID ");
            sb.Append(" AND ploo.LabObservation_ID IN ('LSHHI2') AND ploo.VALUE <>'' GROUP BY ploo.LabObservation_ID ORDER BY ploo.LabObservationName,ploo.ID DESC  ");
            sb.Append("  ),',',( ");
            sb.Append(" SELECT  (CONCAT('NA',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo  INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI267') AND ploo.VALUE <>'' ");
            sb.Append("   GROUP BY ploo.LabObservation_ID ORDER BY ploo.LabObservationName,ploo.ID DESC ");
            sb.Append(" ),',',( ");
            sb.Append("  SELECT  (CONCAT('PL',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI16') AND ploo.VALUE <>'' ");
            sb.Append("  GROUP BY ploo.LabObservation_ID  ORDER BY ploo.LabObservationName,ploo.ID DESC ");
            sb.Append("  ),',',( ");
            sb.Append("  SELECT  (CONCAT('CRE',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI179') AND ploo.VALUE <>'' ");
            sb.Append("  GROUP BY ploo.LabObservation_ID ");
            sb.Append("  ORDER BY ploo.LabObservationName,ploo.ID DESC  ");
            sb.Append("  ),',',( ");
            sb.Append("  SELECT  (CONCAT('K',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI179') AND ploo.VALUE <>'' ");
            sb.Append("  GROUP BY ploo.LabObservation_ID ORDER BY ploo.LabObservationName,ploo.ID DESC )),''))LAB ");
            sb.Append("  FROM patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID WHERE  pmh.TransactionID='" + TID + "' ");
            dt = StockReports.GetDataTable(sb.ToString());
        }
        else { dt = StockReports.GetDataTable(" select id,NoteType,Problem,OnSet,Description,Code,Surgery,ifnull(ifnull(DATE_FORMAT(SurgeryDate,'%d-%b-%Y'),''),'')SurgeryDate,Illness,RelationShip,Issue,DoctorID,PatientID,TransactionID,Createdby,date_format(CreatedDate,'%d-%b-%Y')CreatedDate,(select Concat(Title,' ',Name) from employee_master em where EmployeeID=Createdby)Author from PatientNoteCreation where NoteType='" + NoteTypevalue + "' and Active=1 order by id desc"); }

        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }
    [WebMethod(EnableSession = true)]
    public static string UpdateNotewriterpatientlist(string noteid, string Details)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;
        var message = "";
        try
        {
            sqlCMD = "update notecreationpatient_detail set Detail=@Detail,Updateby=@Updateby,UpdateDate=Now() where ID=@ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Detail = Details,
                Updateby = HttpContext.Current.Session["ID"].ToString(),
                ID = noteid
            });
            message = "Record Update Sucessfully";
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
          
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindpatientprogressnotedata(string encounterType, string encounter, string NoteTypeID)
    {

       

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT IFNULL(ProgressNote,'')ProgressNote,IFNULL(Careplan,'')Careplan FROM nursing_doctorprogressnote WHERE ID='" + NoteTypeID + "' ");


        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }

    [WebMethod(EnableSession = true)]
    public static string updateProgressnotelist(string noteid, string progressnote, string careplan)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;
        var message = "";
        try
        {
            sqlCMD = "update nursing_doctorprogressnote set ProgressNote=@ProgressNote,Careplan=@Careplan,Updateby=@Updateby,UpdateDate=Now() where ID=@ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                ProgressNote = progressnote,
                Careplan=careplan,
                Updateby = HttpContext.Current.Session["ID"].ToString(),
                ID = noteid
            });
            message = "Record Update Sucessfully";
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod (EnableSession = true)]
    public static string bindNoteTypeMaster()
    {
        DataTable dt = StockReports.GetDataTable("select Header_Id,HeaderName from NoteTypeMaster where IsActive=1 ORDER BY SeqNo; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

     

    [WebMethod(EnableSession = true)]
    public static string ViewOrders(string Id)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;
         
        try
        {
            sqlCMD = "update notecreationpatient_detail set IsView=1,ViewBy=@Updateby,ViewByName=@ViewByName,ViewDateTime=now() where ID in (" + Id + ") ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                 
                Updateby = HttpContext.Current.Session["ID"].ToString(),
                ViewByName = HttpContext.Current.Session["EmployeeName"].ToString()
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Acknowledge Successfully." });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string ApproveOrder(string Id, string ApprovedRemark, int isApproved)
    {
        string Message = "Approved Successfully";

        if (isApproved == 0)
        {
            Message = "Rejected Successfully";

        }


        if (GetEmployeeType(HttpContext.Current.Session["ID"].ToString()) == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can not approve." });

        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;

        try
        {
            sqlCMD = "update notecreationpatient_detail set IsApproved=@isApproved,ApprovedRemark=@ApprovedRemark,ApprovedDate=now(),ApprovedBy=@ApprovedBy where ID in (" + Id + ") ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                ApprovedBy = HttpContext.Current.Session["ID"].ToString(),
                ApprovedRemark = ApprovedRemark,
                isApproved = Util.GetInt(isApproved)
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Message });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    public static int GetApprovalType(string EmployeeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.`EmployeeID`,em.`Title`,em.`NAME` FROM  employee_master em WHERE em.`TierID`=8 AND em.`EmployeeID`='" + EmployeeId + "' AND em.`IsActive`=1; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return 0;

        }
        else
        {
            return 1;

        }

    }

    public static int GetEmployeeType(string EmployeeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.`EmployeeID`,em.`Title`,em.`NAME` FROM  employee_master em WHERE em.`TierID`=8 AND em.`EmployeeID`='" + EmployeeId + "' AND em.`IsActive`=1; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return 1;

        }
        else
        {

            return 0;
        }

    }


}