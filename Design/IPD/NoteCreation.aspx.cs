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

public partial class Design_IPD_NoteCreation : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtPSHSurgeryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            if (Request.QueryString["PID"] != null)
            {
                Session["PID"] = Request.QueryString["PID"].ToString();
            }
        }

     
    }
    [WebMethod(EnableSession = true, Description = "Save Patient Note Creation")]

    public static string SavePatentNoteCreation(object NoteCreation)
    {
       
        List<NoteCreation> dataPNC = new JavaScriptSerializer().ConvertToType<List<NoteCreation>>(NoteCreation);
          MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        var Specialty = "";
        var SpecialtyID = "";
        if (HttpContext.Current.Session["RoleID"].ToString() == "52")
        {
            string DoctorID = StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + HttpContext.Current.Session["ID"] + "'");
            if (DoctorID != "")
            {
                string Specialtydetail = StockReports.ExecuteScalar("SELECT CONCAT(tm.ID,'#',tm.NAME)Specialty FROM doctor_master dm  INNER JOIN type_master tm ON tm.NAME=dm.Specialization  WHERE dm.DoctorID='" + DoctorID + "' AND tm.type='Doctor-Specialization'");
                Specialty = Specialtydetail.Split('#')[1];
                SpecialtyID = Specialtydetail.Split('#')[0];
            }

            else
            {
                Specialty = "Other";
                SpecialtyID = "8";
            }
        }
        else
        {
            Specialty = "Other";
            SpecialtyID = "8";
        }
        

        try
        {
            if (dataPNC[0].SurgeryDate == "")
            {
                dataPNC[0].SurgeryDate = "0001-00-00 00:00:00";
            }
            else{dataPNC[0].SurgeryDate=Util.GetDateTime(dataPNC[0].SurgeryDate).ToString("yyyy-MM-dd");}

            string Cadretiertype = StockReports.ExecuteScalar("SELECT CONCAT(ecm.CadreName,'#',etm.tiername,'#',em.cadreID,'#',em.TierID)Cadretier FROM employee_master em INNER JOIN Employee_Cadre_Master ecm ON em.Cadreid=ecm.ID  INNER JOIN Employee_Tier_Master etm ON etm.ID=em.TierID WHERE em.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "'");
            var message = "";
            if (dataPNC[0].NoteType != "PRGNote")
            {
                if (dataPNC[0].SaveType == "Save")
                {
                    var sqlCMD = "insert into PatientNoteCreation (NoteType,Problem,OnSet, Description,Code,Surgery,SurgeryDate,Illness,RelationShip,Issue, DoctorID,PatientID,TransactionID,Createdby,CreatedDate,Cadre,Tier,Specialty,CadreID,TierID,SpecialtyID) ";
                    sqlCMD += " Value (@NoteType,@Problem,@OnSet,@Description,@Code,@Surgery,@SurgeryDate,@Illness,@RelationShip,@Issue,@DoctorID,@PatientID,@TransactionID,@Createdby,@CreatedDate,@Cadre,@Tier,@Specialty,@CadreID,@TierID,@SpecialtyID)";

                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        NoteType = dataPNC[0].NoteType,
                        Problem = dataPNC[0].Problem,
                        OnSet = dataPNC[0].OnSet,
                        Description = dataPNC[0].Description,
                        Code = dataPNC[0].Code,
                        Surgery = dataPNC[0].Surgery,
                        SurgeryDate = dataPNC[0].SurgeryDate,
                        Illness = dataPNC[0].Illness,
                        RelationShip = dataPNC[0].RelationShip,
                        Issue = dataPNC[0].Issue,
                        DoctorID = dataPNC[0].DoctorID,
                        PatientID = dataPNC[0].PatientID,
                        TransactionID = dataPNC[0].TransactionID,
                        Createdby = HttpContext.Current.Session["ID"].ToString(),
                        CreatedDate = Util.GetDateTime(dataPNC[0].NoteCreationDate),
                        Cadre = Cadretiertype.Split('#')[0],
                        Tier = Cadretiertype.Split('#')[1],
                        Specialty = Specialty,
                        CadreID = Cadretiertype.Split('#')[2],
                        TierID = Cadretiertype.Split('#')[3],
                        SpecialtyID = Util.GetInt(SpecialtyID)
                    });
                    message = "Record Save Sucessfully";
                }
                else
                {
                    var sqlCMD = "update PatientNoteCreation pn set pn.NoteType=@NoteType,pn.Problem=Problem,pn.OnSet=@OnSet,pn.Description=@Description,pn.Code=@Code,pn.Surgery=@Surgery,pn.Illness=@Illness,pn.RelationShip=@RelationShip,pn.Issue=@Issue,pn.UpdateDate=now(),pn.Updateby=@Updateby where pn.ID=@ID;";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        NoteType = dataPNC[0].NoteType,
                        Problem = dataPNC[0].Problem,
                        OnSet = dataPNC[0].OnSet,
                        Description = dataPNC[0].Description,
                        Code = dataPNC[0].Code,
                        Surgery = dataPNC[0].Surgery,
                        //SurgeryDate=dataPNC[0].SurgeryDate,
                        Illness = dataPNC[0].Illness,
                        RelationShip = dataPNC[0].RelationShip,
                        Issue = dataPNC[0].Issue,
                        Updateby = HttpContext.Current.Session["ID"].ToString(),
                        ID = Util.GetInt(dataPNC[0].ID)
                    });
                    message = "Record Update Sucessfully";
                }
            }
            else {
                if (dataPNC[0].SaveType == "Save")
                {
                    var sqlCmd = "INSERT INTO nursing_doctorprogressnote(TransactionID,NoteDate,ProgressNote,UserID,Careplan,isActive,Cadre,Tier,Specialty,CadreID,TierID,SpecialtyID)";
                    sqlCmd += "VALUES (@TransactionID,@NoteDate,@ProgressNote,@UserID,@Careplan,@isActive,@Cadre,@Tier,@Specialty,@CadreID,@TierID,@SpecialtyID)";

                    excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                    {
                        TransactionID = dataPNC[0].TransactionID,
                        NoteDate = Util.GetDateTime(dataPNC[0].NoteCreationDate),
                        ProgressNote = dataPNC[0].ProgressNote,
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        Careplan = dataPNC[0].Careplan,
                        isActive = Util.GetInt("1"),
                        Cadre = Cadretiertype.Split('#')[0],
                        Tier = Cadretiertype.Split('#')[1],
                        Specialty = Specialty,
                        CadreID = Cadretiertype.Split('#')[2],
                        TierID = Cadretiertype.Split('#')[3],
                        SpecialtyID = Util.GetInt(SpecialtyID)
                    });
                    message = "Record Save Sucessfully";
                }

                else {
                    var sqlCmd = "UPDATE nursing_doctorprogressnote ndp SET ndp.ProgressNote=@ProgressNote,ndp.Careplan=@ProgressNote,ndp.UpdateBy=@UpdateBy,ndp.UpdateDate=NOW() WHERE ID=@ID";
                    excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                    {
                        ProgressNote = dataPNC[0].ProgressNote,
                        Careplan = dataPNC[0].Careplan,
                        UpdateBy= HttpContext.Current.Session["ID"].ToString(),
                        ID = Util.GetInt(dataPNC[0].ID)

                    });

                    message = "Record Update Sucessfully";
                }
            }


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
    public static string BindPatientNoteCreation(string NoteTypevalue,string TID)
    {
        DataTable dt = new DataTable();
        if (NoteTypevalue == "DM")
        {
            dt = StockReports.GetDataTable(" select '0' as 'IsEdit', dm.Medicinename as DrugName,dm.Time_next_Dose as NextDose,dm.Dose as Dose,dm.Days as Duration,dm.Meal  from discharge_medicine dm where TransactionID='"+TID+"'");
        }

        if (NoteTypevalue == "FD")
        {
            dt = StockReports.GetDataTable(" SELECT  '0' as 'IsEdit',icd.Group_Desc AS Diagnosis,icd.ICD10_3_Code AS DiagnosisCode FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.TransactionID='" + TID + "'");
        }
        else if (NoteTypevalue == "Allergy")
        {
            dt = StockReports.GetDataTable(" select  '0' as 'IsEdit',IFNULL(Allergies,'')Allergies from cpoe_hpexam dm  where TransactionID='" + TID + "'");
        }

        else if (NoteTypevalue == "PRGNote")
        {
            dt = StockReports.GetDataTable("SELECT  '0' as 'IsEdit',DATE_FORMAT(pc.NoteDate,'%d-%b-%Y')Dates,'Progress Note' AS Notetype,(SELECT CONCAT(title,' ',NAME)Author from employee_master em WHERE em.Employeeid=pc.UserID)Author,IFNULL(pc.ProgressNote,'')ProgressNote,IFNULL(pc.Careplan,'')Careplan,PC.ID FROM nursing_doctorprogressnote pc WHERE TransactionID='" + TID + "' and pc.Isactive=1");
        }
        else { dt = StockReports.GetDataTable(" select  '0' as 'IsEdit',id,NoteType,Problem,OnSet,Description,Code,Surgery,ifnull(ifnull(DATE_FORMAT(SurgeryDate,'%d-%b-%Y'),''),'')SurgeryDate,Illness,RelationShip,Issue,DoctorID,PatientID,TransactionID,Createdby,date_format(CreatedDate,'%d-%b-%Y')CreatedDate,(select Concat(Title,' ',Name) from employee_master em where EmployeeID=iu.Createdby)Author from PatientNoteCreation iu where NoteType='" + NoteTypevalue + "' and TransactionID='" + TID + "' and Createdby='" + HttpContext.Current.Session["ID"].ToString() + "'and Active=1 order by  SeqNo,id desc"); }

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  '1' as 'IsEdit',DATE_FORMAT(icdp.EntDate,'%d-%b-%Y')CreatedDate,'ProblemList' as NoteType,(SELECT Concat(Title,' ',Name) 	FROM 	employee_master  WHERE  EmployeeId=UserID LIMIT 0, 1) as Author,WHO_Full_Desc as Problem,'' as OnSet,icdp.Comment1 as Description,ICD10_Code as Code");
        sb.Append(" FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID where icdp.IsActive=1 AND icdp.AddToPatientList=1 ");
        sb.Append(" AND icd.Isactive=1 AND icdp.PatientID='" + HttpContext.Current.Session["PID"].ToString() + "' ");

        DataTable dt1 = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0 || dt1.Rows.Count>0)
        {
            dt1.Merge(dt);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt1 });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }
    [WebMethod(EnableSession = true)]
    public static string DeactivePatientNotes(string id, string Notetype)
    {
        var message = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            if (Notetype == "Progress Note")
            {
                var sqlCMD = "update nursing_doctorprogressnote pt set pt.isActive=@Active,Updateby=@Updateby,UpdateDate=NOW() where pt.ID=@ID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Active = 0,
                    ID = Util.GetInt(id),
                    Updateby = HttpContext.Current.Session["ID"].ToString()
                });
            }
            else
            {

                var sqlCMD = "update PatientNoteCreation pt set pt.Active=@Active,Updateby=@Updateby,UpdateDate=NOW() where pt.ID=@ID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Active = 0,
                    ID = Util.GetInt(id),
                    Updateby = HttpContext.Current.Session["ID"].ToString()
                });
            }

            message = "Record Delete Sucessfully";
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
    public static string notewriterdetailsave(string Detail, string TID, string PatientID, string SaveType, string ID, string DoctorID,string createdate)
    {
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD=string.Empty;
        var message = "";
        var Specialty = "";
        var SpecialtyID = "";
        if (HttpContext.Current.Session["RoleID"].ToString() == "52")
        {
            string typeDoctorID = StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + HttpContext.Current.Session["ID"] + "'");
            if (DoctorID != "")
            {
                string Specialtydetail = StockReports.ExecuteScalar("SELECT CONCAT(tm.ID,'#',tm.NAME)Specialty FROM doctor_master dm  INNER JOIN type_master tm ON tm.NAME=dm.Specialization  WHERE dm.DoctorID='" + typeDoctorID + "' AND tm.type='Doctor-Specialization'");
                Specialty = Specialtydetail.Split('#')[1];
                SpecialtyID = Specialtydetail.Split('#')[0];
            }

            else
            {
                Specialty = "Other";
                SpecialtyID = "ID";
            }
        }
        else
        {
            Specialty = "Other";
            SpecialtyID = "ID";
        }
        try
        {
            
            
            //sqlCMD = "delete from patientnotewriterlist pt where pt.Notewritertype=@Notewritertype and TransactionID=@TransactionID";
            //excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            //{
            //    TransactionID = TID,
            //    Notewritertype = Notewritertype
            //});
            string Cadretiertype = StockReports.ExecuteScalar("SELECT CONCAT(ecm.CadreName,'#',etm.tiername,'#',em.cadreID,'#',em.TierID)Cadretier FROM employee_master em INNER JOIN Employee_Cadre_Master ecm ON em.Cadreid=ecm.ID  INNER JOIN Employee_Tier_Master etm ON etm.ID=em.TierID WHERE em.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "'");
            if (SaveType == "Add Details")
            {

                sqlCMD = "insert into patientnotewriterlist (DoctorID,PatientID,TransactionID,Detail,UserID,CreateDate,Cadre,Tier,Specialty,CadreID,TierID,SpecialtyID)values(@DoctorID,@PatientID,@TransactionID,@Detail,@UserID,@CreateDate,@Cadre,@Tier,@Specialty,@CadreID,@TierID,@SpecialtyID)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    TransactionID = TID,
                    PatientID = PatientID,
                    Detail = Detail,
                    UserID = HttpContext.Current.Session["ID"].ToString(),
                    Cadre = Cadretiertype.Split('#')[0],
                    Tier = Cadretiertype.Split('#')[1],
                    Specialty = Specialty,
                    CadreID = Cadretiertype.Split('#')[2],
                    TierID = Cadretiertype.Split('#')[3],
                    SpecialtyID = Util.GetInt(SpecialtyID),
                    DoctorID = DoctorID,
                   CreateDate= Util.GetDateTime(createdate).ToString("yyyy-MM-dd")

                });

                message = "Record Save Sucessfully";
            }
            else {
                sqlCMD = "update patientnotewriterlist set Detail=@Detail,Updateby=@Updateby,UpdateDate=Now() where ID=@ID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new {
                    Detail = Detail,
                    Updateby = HttpContext.Current.Session["ID"].ToString(),
                    ID=ID
                });
                message = "Record Update Sucessfully";
            }
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
    public static string bindpatientnotewriterdetail(string TID)
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("select pt.ID,concat(date_format(pt.EntryDate,'%d-%b-%Y'),' ',time_format(pt.EntryDate,'%h:%i:%s %p'))CreateDate,concat(em.Title,' ',em.NAME)Author,IFNULL(pt.detail,'')detail,Cadre,Tier,Specialty  from patientnotewriterlist pt inner join employee_master em on em.EmployeeID=pt.UserID where TransactionID='" + TID + "' order by pt.id desc "); 

        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }
    [WebMethod(EnableSession = true)]
    public static string rejectnotewriterentries(string id)
    {
        var message = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var sqlCMD = "delete  from  patientnotewriterlist  where ID=@ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                ID = Util.GetInt(id),
            });

            message = " Record Delete Sucessfully";
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
    public static string bindPatientnotewritedata(string ID)
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT pt.Detail FROM patientnotewriterlist pt WHERE pt.ID='"+ID+"' ");

        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }


     [WebMethod(EnableSession = true, Description = "Save Patient Note Creationtable")]

     public static string SavePatentNoteCreationtable(object NoteCreation)
     {

         List<NoteCreation> dataPNC = new JavaScriptSerializer().ConvertToType<List<NoteCreation>>(NoteCreation);
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         var sqlCMD = string.Empty;
         var Specialty = "";
         var SpecialtyID = "";
         if (HttpContext.Current.Session["RoleID"].ToString() == "52")
         {
             string DoctorID = StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + HttpContext.Current.Session["ID"] + "'");
             if (DoctorID != "")
             {
                 string Specialtydetail = StockReports.ExecuteScalar("SELECT CONCAT(tm.ID,'#',tm.NAME)Specialty FROM doctor_master dm  INNER JOIN type_master tm ON tm.NAME=dm.Specialization  WHERE dm.DoctorID='" + DoctorID + "' AND tm.type='Doctor-Specialization'");
                 Specialty = Specialtydetail.Split('#')[1];
                 SpecialtyID = Specialtydetail.Split('#')[0];
             }

             else
             {
                 Specialty = "Other";
                 SpecialtyID = "8";
             }
         }
         else
         {
             Specialty = "Other";
             SpecialtyID = "8";
         }


         try
         {

             sqlCMD = "delete pt.* from PatientNoteCreation pt where pt.NoteType=@NoteType and TransactionID=@TransactionID and Createdby=@Createdby";
             excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
             {
                 TransactionID =dataPNC[0].TransactionID,
                 NoteType = dataPNC[0].NoteType,
                 Createdby=HttpContext.Current.Session["ID"].ToString()

             });

             string Cadretiertype = StockReports.ExecuteScalar("SELECT CONCAT(ecm.CadreName,'#',etm.tiername,'#',em.cadreID,'#',em.TierID)Cadretier FROM employee_master em INNER JOIN Employee_Cadre_Master ecm ON em.Cadreid=ecm.ID  INNER JOIN Employee_Tier_Master etm ON etm.ID=em.TierID WHERE em.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "'");
             var message = "";
             if (dataPNC[0].NoteType != "PRGNote")
             {
                 if (dataPNC[0].SaveType == "Save")
                 {

                     dataPNC.ForEach(i =>
                         {
                             if (i.SurgeryDate == "")
                             {
                                 i.SurgeryDate = "0001-00-00 00:00:00";
                             }
                             else { i.SurgeryDate = Util.GetDateTime(dataPNC[0].SurgeryDate).ToString("yyyy-MM-dd"); }

                              sqlCMD = "insert into PatientNoteCreation (NoteType,Problem,OnSet, Description,Code,Surgery,SurgeryDate,Illness,RelationShip,Issue, DoctorID,PatientID,TransactionID,Createdby,CreatedDate,Cadre,Tier,Specialty,CadreID,TierID,SpecialtyID,SeqNo) ";
                             sqlCMD += " Value (@NoteType,@Problem,@OnSet,@Description,@Code,@Surgery,@SurgeryDate,@Illness,@RelationShip,@Issue,@DoctorID,@PatientID,@TransactionID,@Createdby,@CreatedDate,@Cadre,@Tier,@Specialty,@CadreID,@TierID,@SpecialtyID,@SeqNo)";

                             excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                             {
                                 NoteType = i.NoteType,
                                 Problem = i.Problem,
                                 OnSet = i.OnSet,
                                 Description = i.Description,
                                 Code = i.Code,
                                 Surgery = i.Surgery,
                                 SurgeryDate = i.SurgeryDate,
                                 Illness = i.Illness,
                                 RelationShip = i.RelationShip,
                                 Issue = i.Issue,
                                 DoctorID = i.DoctorID,
                                 PatientID = i.PatientID,
                                 TransactionID = i.TransactionID,
                                 Createdby = HttpContext.Current.Session["ID"].ToString(),
                                 CreatedDate = Util.GetDateTime(i.NoteCreationDate),
                                 Cadre = Cadretiertype.Split('#')[0],
                                 Tier = Cadretiertype.Split('#')[1],
                                 Specialty = Specialty,
                                 CadreID = Cadretiertype.Split('#')[2],
                                 TierID = Cadretiertype.Split('#')[3],
                                 SpecialtyID = Util.GetInt(SpecialtyID),
                                 SeqNo=Util.GetInt(i.sqno)
                             });
                         });
                     message = "Record Save Sucessfully";
                 }
                
             }
             else
             {
                 if (dataPNC[0].SaveType == "Save")
                 {
                     var sqlCmd = "INSERT INTO nursing_doctorprogressnote(TransactionID,NoteDate,ProgressNote,UserID,Careplan,isActive,Cadre,Tier,Specialty,CadreID,TierID,SpecialtyID)";
                     sqlCmd += "VALUES (@TransactionID,@NoteDate,@ProgressNote,@UserID,@Careplan,@isActive,@Cadre,@Tier,@Specialty,@CadreID,@TierID,@SpecialtyID)";

                     excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                     {
                         TransactionID = dataPNC[0].TransactionID,
                         NoteDate = Util.GetDateTime(dataPNC[0].NoteCreationDate),
                         ProgressNote = dataPNC[0].ProgressNote,
                         UserID = HttpContext.Current.Session["ID"].ToString(),
                         Careplan = dataPNC[0].Careplan,
                         isActive = Util.GetInt("1"),
                         Cadre = Cadretiertype.Split('#')[0],
                         Tier = Cadretiertype.Split('#')[1],
                         Specialty = Specialty,
                         CadreID = Cadretiertype.Split('#')[2],
                         TierID = Cadretiertype.Split('#')[3],
                         SpecialtyID = Util.GetInt(SpecialtyID)
                     });
                     message = "Record Save Sucessfully";
                 }

                 else
                 {
                     var sqlCmd = "UPDATE nursing_doctorprogressnote ndp SET ndp.ProgressNote=@ProgressNote,ndp.Careplan=@ProgressNote,ndp.UpdateBy=@UpdateBy,ndp.UpdateDate=NOW() WHERE ID=@ID";
                     excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                     {
                         ProgressNote = dataPNC[0].ProgressNote,
                         Careplan = dataPNC[0].Careplan,
                         UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                         ID = Util.GetInt(dataPNC[0].ID)

                     });

                     message = "Record Update Sucessfully";
                 }
             }


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
   
}