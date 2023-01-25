using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;


public partial class Design_EDP_MedicalCertificateSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtfrmdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        txtfrmdate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT mc.ID,MC.PName,mc.Address,pm.Mobile,pmh.PatientID,pmh.TransactionID FROM medicalcertificate mc INNER JOIN patient_medical_history pmh ON ");
            //sb.Append(" pmh.PatientID=mc.MRNO INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID WHERE mc.Isactive=1 ");

            sb.Append("  SELECT mc.ID,MC.PName,mc.Address,pm.Mobile,pm.PatientID,mc.TransactionID  ");
            sb.Append(" FROM medicalcertificate mc  INNER JOIN patient_master pm ON pm.PatientID=mc.MRNO WHERE mc.Isactive=1 and EntDate>='" +Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' and EntDate<='" +  Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'   ");


            if (txtmrno.Text.Trim() != "")
            {
                sb.Append("AND mc.MRNO='" + txtmrno.Text.Trim() + "'");
            }
            else if (txtipdno.Text.Trim() != "")
            {
                sb.Append("AND mc.id='" + txtipdno.Text.Trim() + "'");
            }
            else if (txtIPNo.Text.Trim() != "")
            {
                sb.Append("AND mc.TransactionID='" + txtIPNo.Text.Trim() + "'");
            }
            else if (txtmobileno.Text.Trim() != "")
            {
                sb.Append("AND pm.Mobile='" + txtmobileno.Text.Trim() + "'");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
            else
            {
                GridView1.DataSource = null;
                GridView1.DataBind();
            }


        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {

            if (e.CommandName == "RPrint")
            {
                string id = Util.GetString(e.CommandArgument);
                string sql = "  SELECT mc.ID,mc.PName,mc.Address,mc.MRNO,mc.RelationName,mc.Gender,mc.Age,mc.Diagnosis,DATE_FORMAT(mc.fdate,'%d-%b-%y')fdate, DATE_FORMAT(mc.tdate,'%d-%b-%y')tdate,";
                        sql += " DATE_FORMAT(mc.EntDate,'%d-%b-%y')CurrentDate, mc.Remarks,";
                        sql += " mc.TransactionID,mc.DSignature,mc.docdept, mc.DoctorName   "; 
                 sql += " from  medicalcertificate mc where mc.id='" + id + "'";
                DataTable dt = StockReports.GetDataTable(sql);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
           //    ds.WriteXmlSchema("E:/NewMedicalCertificate.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "MedicalCertificate";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../common/Commonreport.aspx');", true);

            }
            if (e.CommandName == "AEdit")
            {


                divptdetail.Visible = true;
                string id = Util.GetString(e.CommandArgument);
                string query = "SELECT ID, PName, Address, MRNO, RelationName, Gender, Age, Diagnosis,DATE_FORMAT(fdate,'%d-%b-%Y')FDate, DATE_FORMAT(TDate,'%d-%b-%Y')TDate, Remarks, UserID, EntDate, IsActive, DoctorName, DSignature, docdept FROM medicalcertificate where id='" + id + "' ";
                DataTable dt = StockReports.GetDataTable(query);
                if (dt.Rows.Count > 0)
                {
                    lblcerid.Text = dt.Rows[0]["ID"].ToString();
                    txtmr.Text = dt.Rows[0]["MRNO"].ToString();
                    txtptname.Text = dt.Rows[0]["PName"].ToString();
                    txtAddress.Text = dt.Rows[0]["Address"].ToString();
                    txtrelation.Text = dt.Rows[0]["RelationName"].ToString();
                    txtgender.Text = dt.Rows[0]["Gender"].ToString();
                    txtage.Text = dt.Rows[0]["Age"].ToString();
                    txtdiagnosis.Text = dt.Rows[0]["Diagnosis"].ToString();
                    txtRemarks.Text = dt.Rows[0]["Remarks"].ToString();
                    txtdrsign.Text = dt.Rows[0]["DSignature"].ToString();
                    txtdocdept.Text = dt.Rows[0]["docdept"].ToString();
                    txtdoctorname.Text = dt.Rows[0]["DoctorName"].ToString();
                    txtfrmdate.Text = dt.Rows[0]["FDate"].ToString();
                    txtToDate.Text = dt.Rows[0]["TDate"].ToString();
                }
              
            }
        }
        catch (Exception ex)

        { 
       
        }
    }
   
    protected void txtsave_Click(object sender, EventArgs e)
    {
        try
        {
            string query = "UPDATE medicalcertificate SET PName='" + txtptname.Text.Trim() + "' ,Address='" + txtAddress.Text.Trim() + "',RelationName='" + txtrelation.Text.Trim() + "',Diagnosis='" + txtdiagnosis.Text.Trim() + "',FDate='" + Util.GetDateTime(txtfrmdate.Text).ToString("yyyy-MM-dd") + "',TDate='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "',Remarks='" + txtRemarks.Text.Trim() + "',DoctorName='" + txtdoctorname.Text + "', DSignature='" + txtdrsign.Text + "', docdept='" + txtdocdept.Text + "' ,userid='" + Session["ID"].ToString() + "',EntDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' WHERE IsActive='1' and id='" + lblcerid.Text + "' ";
            StockReports.ExecuteDML(query);
            lblMsg.Text = "Record Save Successfully";
            divptdetail.Visible = false;           

            string sql = "  SELECT mc.ID,mc.PName,mc.Address,mc.MRNO,mc.RelationName,mc.Gender,mc.Age,mc.Diagnosis,DATE_FORMAT(mc.fdate,'%d-%b-%y')fdate, DATE_FORMAT(mc.tdate,'%d-%b-%y')tdate,";
            sql += " DATE_FORMAT(mc.EntDate,'%d-%b-%y')CurrentDate, Remarks,mc.DoctorName, ";
            sql += " (SELECT REPLACE(TransactionID,'ISHHI','')TransactionID ";
            sql += " FROM  patient_medical_history WHERE PatientID=mc.mrno LIMIT 1)TransactionID,mc.DSignature,mc.docdept   ";
            sql += " from  medicalcertificate mc where mc.id='" + lblcerid.Text + "'";
            DataTable dt = StockReports.GetDataTable(sql);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
           // ds.WriteXmlSchema("E:/NewMedicalCertificate.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "MedicalCertificate";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../common/Commonreport.aspx');", true);
            clear();
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();  
        }
    }

    private void clear()
    {
        txtptname.Text = "";
        txtmr.Text = "";
        txtAddress.Text = "";
        txtage.Text = "";
        txtdiagnosis.Text = "";
        txtfrmdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtgender.Text = "";
        txtRemarks.Text = "";
        txtrelation.Text = "";
        txtdoctorname.Text = "";
    }
}
