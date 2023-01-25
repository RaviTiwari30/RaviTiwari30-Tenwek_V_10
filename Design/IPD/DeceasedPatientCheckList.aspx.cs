using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;

public partial class Design_IPD_DeceasedPatientCheckList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        
        if (!IsPostBack)
        {

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["UserID"] = Session["ID"].ToString(); ;
            
            string a = ViewState["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();

            ViewState["TransID"] = TID;
            dt = AllLoadData_IPD.getAdmitDischargeData(TID);
            caldate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
            if (dt.Rows[0]["Status"].ToString() == "OUT")
            {
                caldate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
                CalDeath.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
            }
            else
            {
                caldate.EndDate = DateTime.Now;
            }
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtDateContact.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtTimeContact.Text = DateTime.Now.ToString("hh:mm tt");

            caldate.EndDate = DateTime.Now;
            CalDeath.EndDate = DateTime.Now;
        }
        txtDate.Attributes.Add("readOnly", "true");
        txtDateContact.Attributes.Add("readOnly", "true");
        txtDateDeath.Attributes.Add("readOnly", "true");
    }


    [WebMethod(EnableSession = true)]
    public static string BindPatientDetail(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.PatientID,CONCAT(pm.Title,'',pm.PName)Pname,REPLACE(pmh.TransactionID,'ISHHI','')IPDNO,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.City,' ',pm.Country)address ");
        sb.Append(" ,pm.Religion,DATE_FORMAT(TimeOfDeath,'%d-%b-%Y')DateofDeath,TIME_FORMAT(pmh.TimeOfDeath,'%l:%i %p')TimeofDeath,NextOfKinInformed,ContactBy,TIME_FORMAT(TimeofContact,'%l:%i %p') TimeofContact,DATE_FORMAT(DateofContact,'%d-%b-%Y') DateofContact,PropertyReturn,DentureinPlace,JewelleryinPlace,TypeOfJewellery,IsWishbyRelative, ");
        sb.Append(" AnyOtherWish,LastOffice,ReadBackbyKin,Comments,dck.ID,dck.CreateDate,IF(IFNULL(CreateBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreateDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'1')IsEdit FROM patient_master pm  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID ");
        sb.Append(" LEFT JOIN IPD_DesceasedPatientChecklist dck ON dck.TransactionID=pmh.TransactionID AND dck.IsActive=1");
        sb.Append(" WHERE pmh.TransactionID='" + TID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCheckList(object Data, string TID, string PID)
    {
        List<CheckList> checklist = new JavaScriptSerializer().ConvertToType<List<CheckList>>(Data);
        if (checklist.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < checklist.Count; i++)
                {
                    sb.Append("INSERT INTO ipd_desceasedpatientchecklist (TransactionID,PatientID,NextOfKinInformed,ContactBy,TimeofContact, ");
                    sb.Append("DateofContact,PropertyReturn,DentureinPlace,JewelleryinPlace,TypeOfJewellery,IsWishbyRelative, ");
                    sb.Append("AnyOtherWish,LastOffice,ReadBackbyKin,Comments,CreateBy,CreateDate) ");
                    sb.Append("VALUES('"+TID+"','"+PID+"',"+checklist[i].NextOfKinInformed+",'"+checklist[i].ContactBy+"','"+Util.GetDateTime(checklist[i].TimeofContact).ToString("HH:mm:ss")+"',  ");
                    sb.Append(" '" + Util.GetDateTime(checklist[i].DateofContact).ToString("yyyy-MM-dd") + "'," + Util.GetInt(checklist[i].PropertyReturn) + "," + Util.GetInt(checklist[i].DentureinPlace) + ","+ Util.GetInt(checklist[i].JewelleryinPlace)+",'"+checklist[i].TypeOfJewellery+"'," + Util.GetInt(checklist[i].IsWishbyRelative) + ", ");
                    sb.Append(" '" + checklist[i].AnyOtherWish + "'," + Util.GetInt(checklist[i].LastOffice) + "," + Util.GetInt(checklist[i].ReadBackbyKin) + ",'"+checklist[i].Comments+"','"+HttpContext.Current.Session["ID"].ToString()+"',NOW() ); ");

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                }

                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }


    [WebMethod(EnableSession = true)]
    public static string UpdateCheckList(object Data, string TID, string PID)
    {
        List<CheckList> checklist = new JavaScriptSerializer().ConvertToType<List<CheckList>>(Data);
        if (checklist.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < checklist.Count; i++)
                {
                    string str = "Update ipd_desceasedpatientchecklist set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() where ID= '" + checklist[i].ID + "' ";
                    int result = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    if (result == 1)
                    {
                        sb.Append("INSERT INTO ipd_desceasedpatientchecklist (TransactionID,PatientID,NextOfKinInformed,ContactBy,TimeofContact, ");
                        sb.Append("DateofContact,PropertyReturn,DentureinPlace,JewelleryinPlace,TypeOfJewellery,IsWishbyRelative, ");
                        sb.Append("AnyOtherWish,LastOffice,ReadBackbyKin,Comments,CreateBy,CreateDate) ");
                        sb.Append("VALUES('" + TID + "','" + PID + "'," + checklist[i].NextOfKinInformed + ",'" + checklist[i].ContactBy + "','" + Util.GetDateTime(checklist[i].TimeofContact).ToString("HH:mm:ss") + "',  ");
                        sb.Append(" '" + Util.GetDateTime(checklist[i].DateofContact).ToString("yyyy-MM-dd") + "'," + Util.GetInt(checklist[i].PropertyReturn) + "," + Util.GetInt(checklist[i].DentureinPlace) + "," + Util.GetInt(checklist[i].JewelleryinPlace) + ",'" + checklist[i].TypeOfJewellery + "'," + Util.GetInt(checklist[i].IsWishbyRelative) + ", ");
                        sb.Append(" '" + checklist[i].AnyOtherWish + "'," + Util.GetInt(checklist[i].LastOffice) + "," + Util.GetInt(checklist[i].ReadBackbyKin) + ",'" + checklist[i].Comments + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(checklist[i].CreatedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ) ");

                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                    }
                }

                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.PatientID,CONCAT(pm.Title,'',pm.PName)Pname,REPLACE(pmh.TransactionID,'ISHHI','')IPDNO,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.City,' ',pm.Country)address ");
        sb.Append(" ,pm.Religion,DATE_FORMAT(TimeOfDeath,'%d-%b-%Y')DateofDeath,TIME_FORMAT(pmh.TimeOfDeath,'%l:%i %p')TimeofDeath,if(NextOfKinInformed='1','YES','NO')NextOfKinInformed,ContactBy,TIME_FORMAT(TimeofContact,'%l:%i %p') TimeofContact,DATE_FORMAT(DateofContact,'%d-%b-%Y') DateofContact,if(PropertyReturn='1','YES','NO')PropertyReturn,if(DentureinPlace='1','YES','NO')DentureinPlace,if(JewelleryinPlace='1','YES','NO')JewelleryinPlace,TypeOfJewellery,if(IsWishbyRelative='1','YES','NO')IsWishbyRelative, ");
        sb.Append(" AnyOtherWish,if(LastOffice='1','YES','NO')LastOffice,if(ReadBackbyKin='1','YES','NO')ReadBackbyKin,Comments,dck.ID,dck.CreateDate FROM patient_master pm  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID ");
        sb.Append(" LEFT JOIN IPD_DesceasedPatientChecklist dck ON dck.TransactionID=pmh.TransactionID AND dck.IsActive=1");
        sb.Append(" WHERE pmh.TransactionID='" + ViewState["TransID"].ToString() + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "DeceasedPatientCheckList";

        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";

        Session["ReportName"] = "DeceasedPatientCheckList";
        Session["ds"] = ds;
        
        //ds.WriteXmlSchema(@"E:\DeceasedPatientCheckList.xml");

        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
    }

    public class CheckList
    {
        public int NextOfKinInformed { get; set; }
        public int PropertyReturn { get; set; }
        public int DentureinPlace { get; set; }
        public int JewelleryinPlace { get; set; }
        public int IsWishbyRelative { get; set; }
        public int LastOffice { get; set; }
        public int ReadBackbyKin { get; set; }
        public string ContactBy { get; set; }
        public string TimeofContact { get; set; }
        public string DateofContact { get; set; }
        public string TypeOfJewellery { get; set; }
        public string AnyOtherWish { get; set; }
        public string Comments { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ID { get; set; }
    }
}