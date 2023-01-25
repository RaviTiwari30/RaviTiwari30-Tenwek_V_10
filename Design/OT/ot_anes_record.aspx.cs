using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_ot_anes_record : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
      
            BindPreviousDetails();
        }
    }

    public void BindBasicDetails(string PID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(Title,'',Pname)NAME ,Age ,Gender  FROM patient_master Pm WHERE pm.PatientId='" + PID + "'");

        if (dt.Rows.Count > 0)
        {
            lblName.Text = dt.Rows[0]["NAME"].ToString();
            lblAge.Text = dt.Rows[0]["Age"].ToString();

            lblSex.Text = dt.Rows[0]["Gender"].ToString();

            lblIDs.Text = PID;
        }

    }


    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string dt = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");

            StringBuilder sbupdate = new StringBuilder();
            sbupdate.Append("update cocoa_anes_record set isActive=0,UpdateBy='" + Util.GetString(Session["ID"].ToString()) + "',UpdateDate=NOW() where Transaction_Id='" + ViewState["TID"] + "' and Patient_Id='" + ViewState["PID"] + "' ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbupdate.ToString());



            StringBuilder sb = new StringBuilder();

            sb.Append(" Insert Into cocoa_anes_record(Transaction_Id,Patient_Id,Height,Weight,BMI,Allergies,Date,PreOpDiag,ProOp,IntroOpDiag,OPTyp,Operation,BG,UnitAvailable,EntryBy)");
            sb.Append(" VALUES('" + ViewState["TID"] + "','" + ViewState["PID"] + "','" + txtHeight.Text + "','" + txtWeight.Text + "','" + txtBMI.Text + "',");
            sb.Append(" '" + txtAllergies.Text + "','" + dt + "','" + txtPreOpDiagnosis.Text + "','" + txtPropOp.Text + "','" + txtIntroOpDiag.Text + "','" + txtOpType.Text + "','"+txtOperation.Text+"' ,'" + txtBG.Text + "','" + txtUnitAvailable.Text + "','" + ViewState["UserID"] + "' )");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();

            lblMsg.Text = "Record Saved Successfully";
            clear();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }



    public void BindPreviousDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(pm.Title,'',pm.PName)NAME,pm.Age,pm.Gender Sex,DATE_FORMAT(car.Date,'%d-%b-%Y')DateAns,car.* FROM cocoa_anes_record car ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=car.Patient_Id ");
        sb.Append(" WHERE  car.IsActive=1 AND car.Patient_Id='" + ViewState["PID"] + "' AND car.Transaction_Id='" + ViewState["TID"] + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count>0)
        {
            txtHeight.Text = dt.Rows[0]["Height"].ToString();
            txtWeight.Text = dt.Rows[0]["Weight"].ToString();
            txtBMI.Text = dt.Rows[0]["BMI"].ToString();
            txtAllergies.Text = dt.Rows[0]["Allergies"].ToString();
            txtPreOpDiagnosis.Text = dt.Rows[0]["PreOpDiag"].ToString();
            txtPropOp.Text = dt.Rows[0]["ProOp"].ToString();
            txtIntroOpDiag.Text = dt.Rows[0]["IntroOpDiag"].ToString();
            txtOpType.Text = dt.Rows[0]["OPTyp"].ToString();
            txtBG.Text = dt.Rows[0]["BG"].ToString();
            txtUnitAvailable.Text = dt.Rows[0]["UnitAvailable"].ToString();
            lblName.Text = dt.Rows[0]["NAME"].ToString();
            lblAge.Text = dt.Rows[0]["Age"].ToString();
            txtOperation.Text = dt.Rows[0]["Operation"].ToString();
            lblSex.Text = dt.Rows[0]["sex"].ToString();

            lblIDs.Text = Util.GetString(ViewState["PID"]);
            btnSave.Text = "Update";
        }
        else
        {
            BindBasicDetails(Util.GetString(ViewState["PID"]));
            btnSave.Text = "Save";
        }
      
    
    }


    public void clear()
    {

        txtHeight.Text = "";
        txtWeight.Text = "";
        txtBMI.Text = "";
        txtAllergies.Text = "";
        txtPreOpDiagnosis.Text = "";
        txtPropOp.Text = "";
        txtIntroOpDiag.Text = "";
        txtOpType.Text = "";
        txtBG.Text = "";
        txtUnitAvailable.Text = "";
        txtOperation.Text = "";
    }


}