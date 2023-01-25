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

public partial class Design_EDP_MedicalCertificate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtfrmdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            fc1.EndDate = DateTime.Now;
            fc2.EndDate = DateTime.Now;
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        txtfrmdate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        if(!chkdte.Checked)
        {
        if ((txtmrno.Text=="" )&&( txtptname.Text=="") &&( txtipdno.Text=="") )
        {
            lblMsg.Text = "Please provide any Information for search Patient Detail ";
            return;
        
        }
    }

        try
        {
            lblMsg.Text = "";


            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pm.PNAME,pmh.PatientID,Ifnull(pmh.Transno,'')IPDNo,pmh.TransactionID,pm.Mobile,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City,' ',if(PM.Pincode<>'0',pm.Pincode,''))Address FROM ");

            if (txtmrno.Text.Trim() != "" || txtipdno.Text.Trim() != "")
            {
                sb.Append("( ");
                sb.Append("     Select * from patient_medical_history ");
                if (txtmrno.Text.Trim() != "")
                {
                    sb.Append(" where  PatientID='" + txtmrno.Text + "'");
                }
                else if (txtipdno.Text.Trim() != "")
                {
                    sb.Append(" where TransNo='" + txtipdno.Text + "'");
                }
                else if(txtmrno.Text.Trim() != "" && txtipdno.Text.Trim() != "")
                {
                    sb.Append(" where TransNo='" + txtipdno.Text + "' and PatientID='" + txtmrno.Text + "' ");
                }
                sb.Append(" order by DateOfVisit desc,TIME desc limit 1)pmh ");
            }
            else
                sb.Append(" patient_medical_history pmh ");

            sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");

            if (txtmrno.Text.Trim() != "")
            {
                sb.Append(" where  pm.PatientID='" + txtmrno.Text + "'");
            }
            else if (txtipdno.Text.Trim() != "")
            {
                sb.Append(" where pmh.TransNo='" + txtipdno.Text + "'");
            }
            else if (txtmobileno.Text.Trim() != "")
            {
                sb.Append(" where pm.Mobile='" + txtmobileno.Text + "'");
            }
            else if (txtpatientname.Text.Trim() != "")
            {
                sb.Append(" where pm.PName='" + txtpatientname.Text + "'");
            }
            else if (chkdte.Checked)
            {
                if (ucFromDate.Text.ToString() != string.Empty)
                {
                    sb.Append(" AND DATE(pmh.DateOfVisit)>= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (ucToDate.Text.ToString() != string.Empty)
                {
                    sb.Append("AND DATE(pmh.DateOfVisit)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");
                }
            }

            sb.Append(" GROUP BY pm.PatientID");
          
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
            lblMsg.Text = "Record Not Found";
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {            
            if (e.CommandName == "Select")
            {
                string TransactionID = Util.GetString(e.CommandArgument);
                ViewState["TransactionID"] = "";
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) From medicalcertificate where TransactionID='" + TransactionID + "'"));
                if (count > 0)
                {
                    lblMsg.Text = "Certificate already created as per Patient's Last OPD Bill / IP No.";
                    return ;
                }

                divptdetail.Visible = true;

                string query = "SELECT (pm.PatientID)MRNO,pmh.dateofvisit Fromdate ,CONCAT(pm.Title,pm.PName)NAME,pmh.DoctorID doctorid,(SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE em.employeeID='" + Session["ID"].ToString() + "')doctorname ,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City,' ',if(pm.Pincode='','',pm.Pincode))Address, pm.Age, pm.Gender,pmh.TransactionID FROM patient_master pm INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID INNER JOIN doctor_master dm ON pmh.DoctorID=dm.DoctorID WHERE pmh.TransactionID='" + TransactionID + "' ORDER BY pmh.TransactionID DESC LIMIT 1";
                DataTable dt = StockReports.GetDataTable(query);
                if (dt.Rows.Count > 0)
                {
                    txtmr.Text = dt.Rows[0]["MRNO"].ToString();
                    txtptname.Text = dt.Rows[0]["Name"].ToString();
                    txtAddress.Text = dt.Rows[0]["Address"].ToString();
                    txtgender.Text = dt.Rows[0]["Gender"].ToString();
                    txtage.Text = dt.Rows[0]["Age"].ToString();
                    txtdoctorname.Text = dt.Rows[0]["doctorname"].ToString();
                    ViewState["TransactionID"] = TransactionID;
                }
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "error";
        }        
    }

    protected void txtsave_Click(object sender, EventArgs e)
    {
        try
        {
            var PNmae = txtptname.Text.Trim();
            AllInsert al = new AllInsert();
            string id = al.InsertMedicalCertificate(txtmr.Text.Trim(), txtptname.Text.Trim(), txtAddress.Text.Trim(), txtrelation.Text.Trim(), txtgender.Text.Trim(), txtage.Text.Trim(), txtdiagnosis.Text.Trim(), Util.GetDateTime(txtfrmdate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), txtRemarks.Text.Trim(), txtdoctorname.Text.Trim(), txtdrsign.Text.Trim(), txtdocdept.Text.Trim(), ViewState["TransactionID"].ToString(), Session["ID"].ToString());
            //string insert = "insert into medicalcertificate(PName,Address,MRNO,RelationName,Age,Gender,Diagnosis,FDate,TDate,JoinningDate,UserID,DoctorName,DSignature,docdept,TransactionID)";
            //insert += " Values ('" + txtptname.Text.Trim() + "','" + txtAddress.Text.Trim() + "','" + txtmr.Text.Trim() + "','" + txtrelation.Text.Trim() + "','" + txtage.Text.Trim() + "','" + txtgender.Text.Trim() + "',";
            //insert += "'" + txtdiagnosis.Text.Trim() + "','" + txtfrmdate.GetDateForDataBase() + "','" + txtToDate.GetDateForDataBase() + "','" + txtjoining.Text.Trim() + "','" + ViewState["ID"].ToString() + "','" + txtdoctorname.Text.Trim() + "','" + txtdrsign.Text.Trim() + "','" + txtdocdept.Text.Trim() + "','" + Util.GetString(ViewState["TransactionID"]) + "')";
            //StockReports.ExecuteDML(insert);
            lblMsg.Text = "Record Save Successfully";
            clear();

          //  string id = StockReports.ExecuteScalar("SELECT MAX(ID)FROM medicalcertificate").ToString();
            string sql = " SELECT  mc.ID,mc.PName,mc.Address,mc.MRNO,mc.RelationName,mc.DoctorName,mc.Gender,mc.Age,mc.Diagnosis,mc.DSignature,mc.Remarks,DATE_FORMAT(mc.FDate,'%d-%b-%y')FDate,DATE_FORMAT(mc.TDate,'%d-%b-%y')TDate,DATE_FORMAT(mc.EntDate,'%d-%b-%y')CurrentDate,";
            sql += " REPLACE(pmh.TransactionID,'ISHHI','')TransactionID,mc.DSignature,mc.docdept FROM  patient_medical_history pmh INNER JOIN ";
            sql += "medicalcertificate mc ON pmh.PatientID =mc.MRNO where mc.id='" + id + "' order by mc.id desc  ";
            DataTable dt = StockReports.GetDataTable(sql);
            
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
           // ds.WriteXml("E:/NewMedicalCertificate.xml");
            Session["ds"] = ds;
            if (rblReportFormatType.SelectedValue == "Medical")
            {
                Session["ReportName"] = "MedicalCertificate";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../common/Commonreport.aspx');", true);
            }
            else if (rblReportFormatType.SelectedValue == "Emergency")
            {
                Session["ReportName"] = "EmergencyCertificate";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../common/Commonreport.aspx');", true);
            }
            else
            {
                Session["ReportName"] = "FitnessCertificate";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../common/Commonreport.aspx');", true);
            }
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
        //txtfrmdate.Text = "";
        //txtToDate.Text = "";
        txtgender.Text = "";
       // txtjoining.Text = "";
        txtRemarks.Text = "";
        txtrelation.Text = "";
    }
}
