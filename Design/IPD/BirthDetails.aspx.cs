using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
public partial class Design_ip_BirthDetails : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

        caldate.EndDate = DateTime.Now;
        if (!IsPostBack)
        {
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //txtTime.Text = DateTime.Now.ToString("hh:mm tt"); 

            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                
            grdSickPatientsbind();
            //txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            //txtTime.Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            //((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PatientID"].ToString();
        }
        ViewState["PID"] = Request.QueryString["PatientID"].ToString();
        //grdSickPatientsbind();

        txtDate.Attributes.Add("readOnly", "true");
    }

    protected void grdSickPatientsDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void grdSickPatientsDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblPID.Text = ((Label)grdSickPatientsDetails.Rows[id].FindControl("lblID")).Text;

            DataTable dt = (DataTable)ViewState["dt"];
            DataRow[] rows = dt.Select("Id = '" + lblPID.Text + "'");
            if (rows.Length > 0)
            {
                txtMothersEncounterNr.Text = rows[0]["MothersEncounterNr"].ToString();
                txtDeliveryNrpara.Text = rows[0]["DeliveryNrpara"].ToString();
                txtDeliveryPlace.Text = rows[0]["DeliveryPlace"].ToString();
                txtDeliveryMode.Text = rows[0]["DeliveryMode"].ToString();
                txtFacepresentation.Text = rows[0]["Facepresentation"].ToString();
                txtDeliveryrank.Text = rows[0]["Deliveryrank"].ToString();
                txtApgarscore1min.Text = rows[0]["Apgarscore1min"].ToString();
                txtApgarscore5min.Text = rows[0]["Apgarscore5min"].ToString();
                txtApgarscore10min.Text = rows[0]["Apgarscore10min"].ToString();
                txtCondition.Text = rows[0]["Condition"].ToString();
                txtWeightatbirth.Text = rows[0]["Weightatbirth"].ToString();
                txtLengthatbirth.Text = rows[0]["Lengthatbirth"].ToString();
                txtHeadcircumference.Text = rows[0]["Headcircumference"].ToString();
                txtScoredgestationalage.Text = rows[0]["Scoredgestationalage"].ToString();
                txtFeeding.Text = rows[0]["Feeding"].ToString();
                txtCongenitalabnormality.Text = rows[0]["Congenitalabnormality"].ToString();
                txtOutcome.Text = rows[0]["Outcome"].ToString();


                txtDate.Text = rows[0]["Date1"].ToString();
                ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(rows[0]["Time"].ToString()).ToString("hh:mm tt");
            }
            btnUpdate.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = true;
        }
    }
    public void grdSickPatientsbind()
    {
        DataTable dt = GetSickPatients();
        ViewState["dt"] = dt;
        grdSickPatientsDetails.DataSource = dt;
        grdSickPatientsDetails.DataBind();


    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
    }
    private DataTable GetSickPatients()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT ID,DATE_FORMAT(DATE,'%d-%M-%Y') AS Date1,FirstDegreeTear,SecondDegreeTear,ThirdDegreeTear,FourthDegreeTear,Episiotomy,NewBornResuscitated,PatientID,TransactionID  FROM delivery_master where TransactionID='" + Util.GetString(ViewState["TID"]) + "'");

            sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(Time,'%h:%i %p') AS Time1,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CVE.EntryBy LIMIT 0, 1) AS EntryBy1  FROM BirthDetails  CVE where CVE.PatientId='" + ViewState["PID"] + "'");


            DataTable dt = StockReports.GetDataTable(sb.ToString());


            return dt;
        }
        catch (Exception exc)
        {
            return null;
        }


    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string query = "INSERT INTO `birthdetails` (    `MothersEncounterNr`,  `DeliveryNrpara`,  `DeliveryPlace`,  `DeliveryMode`,  `Facepresentation`,"+
"  `Deliveryrank`,  `Apgarscore1min`,  `Apgarscore5min`,  `Apgarscore10min`,  `Condition`,  `Weightatbirth`,  `Lengthatbirth`,  `Headcircumference`,  `Scoredgestationalage`,  `Feeding`,"+
"  `Congenitalabnormality`,  `Outcome`,  `Date`,  `Time`,  `EntryBy`,`PatientId`) VALUES  (   '" + txtMothersEncounterNr.Text + "',   '" + txtDeliveryNrpara.Text + "',   '" + txtDeliveryPlace.Text
   + "',   '" + txtDeliveryMode.Text + "',   '" + txtFacepresentation.Text + "','" +
   txtDeliveryrank.Text + "',   '" + txtApgarscore1min.Text + "',   '" + txtApgarscore5min.Text + "',   '" + txtApgarscore10min.Text + "',   '" + txtCondition.Text + "',   '" +
   txtWeightatbirth.Text + "',   '" + txtLengthatbirth.Text + "',   '" + txtHeadcircumference.Text + "','" +
   txtScoredgestationalage.Text + "',   '" + txtFeeding.Text + "',   '" + txtCongenitalabnormality.Text + "',   '" + txtOutcome.Text + "','" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "','" + Session["ID"].ToString() + "' ,'" + ViewState["PID"] + "' );";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            Clear();
            grdSickPatientsbind();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('saved successfully');", true);

        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('not saved');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    private void Clear()
    {
        txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            
        txtMothersEncounterNr.Text = "";
        txtDeliveryNrpara.Text = "";
        txtDeliveryPlace.Text = "";
        txtDeliveryMode.Text = "";
        txtFacepresentation.Text = "";
        txtDeliveryrank.Text = "";
        txtApgarscore1min.Text = "";
        txtApgarscore5min.Text = "";
        txtApgarscore10min.Text = "";
        txtCondition.Text = "";
        txtWeightatbirth.Text = "";
        txtLengthatbirth.Text = "";
        txtHeadcircumference.Text = "";
        txtScoredgestationalage.Text = "";
        txtFeeding.Text = "";
        txtCongenitalabnormality.Text = "";
        txtOutcome.Text = "";
                
       

        btnUpdate.Visible = false;
        btnSave.Visible = true;
        btnCancel.Visible = false;


    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        //if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        //{

        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('only past dates allowed');", true);
        //    return;
        //}
        try
        {
            //string time = Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss");
            string query = "UPDATE `birthdetails` SET    `MothersEncounterNr` = '"+txtMothersEncounterNr.Text+"',"+
"  `DeliveryNrpara` = '"+txtDeliveryNrpara.Text+"',  `DeliveryPlace` = '"+txtDeliveryPlace.Text+"',  `DeliveryMode` = '"+txtDeliveryMode.Text+"',  `Facepresentation` = '"+txtFacepresentation.Text+"',  `Deliveryrank` = '"+txtDeliveryrank.Text+"',"+
"  `Apgarscore1min` = '"+txtApgarscore1min.Text+"',  `Apgarscore5min` = '"+txtApgarscore5min.Text+"',  `Apgarscore10min` = '"+txtApgarscore10min.Text+"',  `Condition` = '"+txtCondition.Text+"',  `Weightatbirth` = '"+txtWeightatbirth.Text+"',"+
"  `Lengthatbirth` = '"+txtLengthatbirth.Text+"',  `Headcircumference` = '"+txtHeadcircumference.Text+"',  `Scoredgestationalage` = '"+txtScoredgestationalage.Text+"',  `Feeding` = '"+
txtFeeding.Text+"',  `Congenitalabnormality` = '"+txtCongenitalabnormality.Text+"',"+
"  `Outcome` = '" + txtOutcome.Text + "',  `Date` = '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',   `Time` = '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "' WHERE ID=" + lblPID.Text + " ";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            Clear();
            grdSickPatientsbind();

            btnSave.Visible = true;
            btnUpdate.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('updated successfully');", true);

        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('not updated');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}