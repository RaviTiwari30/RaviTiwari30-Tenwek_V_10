using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_BloodTransfusion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ViewState["UserID"] = Session["ID"].ToString();
            if (Request.QueryString["TransactionID"] != null)
            {
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                ViewState["EMGNo"] = "";
            }
            else
            {
                ViewState["TID"] = Request.QueryString["TID"].ToString();
                ViewState["PID"] = Request.QueryString["PID"].ToString();
                ViewState["EMGNo"] = Request.QueryString["EMGNo"].ToString(); 
            }
            BindData();
            if (ddlBatchNo.Items.Count != 0)
            {
                string bb = ddlBatchNo.SelectedItem.Value;
                search(bb);
            }



        }
    }

    private void BindData()
    {
        string str = "SELECT BBTubeNo,CONCAT(BBTubeNo,'-', ComponentName) `ComponentWithTube`  FROM bb_issue_blood where TransactionID='" + ViewState["TID"].ToString() + "'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlBatchNo.DataSource = dt;
            ddlBatchNo.DataTextField = "ComponentWithTube";
            ddlBatchNo.DataValueField = "BBTubeNo";
            ddlBatchNo.DataBind();


        }

        else
        {
            ddlBatchNo.Items.Clear();
            lblMg.Text = "Blood Transfusion Form Cannot be Filled against this patient";
            btnSubmit.Visible = false;
        }
    }



    private void search(string batch)
    {
        string str = " SELECT bib.Issuevolumn,bib.BagType,(SELECT  BloodGroup FROM bb_stock_master WHERE Stock_Id=bib.`Stock_ID`) bloodGroup  FROM bb_issue_blood bib where TransactionID='" + ViewState["TID"].ToString() + "'  AND  BBTubeNo='" + batch + "' ";

        DataTable dt2 = StockReports.GetDataTable(str);
        if (dt2.Rows.Count > 0)
        {
            lblQuantity.Text = dt2.Rows[0]["Issuevolumn"].ToString();
            lblGroup.Text = dt2.Rows[0]["bloodGroup"].ToString();
            lblBBankNo.Text = dt2.Rows[0]["BagType"].ToString();
        }

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Temparature_Before,Temparature_During,Temparature_After,Pulse_Before,Pulse_During,Pulse_After,BloodPressure_Before, BloodPressure_During ,BloodPressure_After,IsChill,IsRigor,IsRashes , IsPainBack, IsHead,IsChest,IsElse,IsHaemoglobin,IsPulmonry,IsJuandice,IsOther,IFNULL(UpdatedBy,CreatedBy)user   FROM bb_BloodTransfusion where TransactionID='" + ViewState["TID"].ToString() + "'  AND BatchNo='" + batch + "'");
        //   sb.Append("SELECT Quantity_Given,BloodBank_No,GroupAndRh,Temparature_Before,Temparature_During,Temparature_After,Pulse_Before,Pulse_During,Pulse_After,BloodPressure_Before, BloodPressure_During ,BloodPressure_After,IsChill,IsRigor,IsRashes , IsPainBack, IsHead,IsChest,IsElse,IsHaemoglobin,IsPulmonry,IsJuandice,IsOther  FROM bb_BloodTransfusion ORDER BY id DESC LIMIT 1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            //txtBBankNo.Text = dt.Rows[0]["BloodBank_No"].ToString();
            //txtGroup.Text = dt.Rows[0]["GroupAndRh"].ToString();
            //txtQuantity.Text = dt.Rows[0]["Quantity_Given"].ToString();
            txtTemBefor.Text = dt.Rows[0]["Temparature_Before"].ToString();
            txtTemDuring.Text = dt.Rows[0]["Temparature_During"].ToString();
            txtTemAfter.Text = dt.Rows[0]["Temparature_After"].ToString();
            txtPulseBefore.Text = dt.Rows[0]["Pulse_Before"].ToString();
            txtPulseDuring.Text = dt.Rows[0]["Pulse_During"].ToString();
            txtPulseAfter.Text = dt.Rows[0]["Pulse_After"].ToString();
            txtBloodBefore.Text = dt.Rows[0]["BloodPressure_Before"].ToString();
            txtBloodDuring.Text = dt.Rows[0]["BloodPressure_During"].ToString();
            txtBloodAfter.Text = dt.Rows[0]["BloodPressure_After"].ToString();
            rbtChills.SelectedValue = dt.Rows[0]["IsChill"].ToString();
            rbtRigor.SelectedValue = dt.Rows[0]["IsRigor"].ToString();
            rbtRash.SelectedValue = dt.Rows[0]["IsRashes"].ToString();
            rbtPolmonary.SelectedValue = dt.Rows[0]["IsPulmonry"].ToString();
            rbtPain.SelectedValue = dt.Rows[0]["IsPainBack"].ToString();
            rbtJaundice.SelectedValue = dt.Rows[0]["IsJuandice"].ToString();
            rbtHead.SelectedValue = dt.Rows[0]["IsHead"].ToString();
            rbtHaemo.SelectedValue = dt.Rows[0]["IsHaemoglobin"].ToString();
            rbtChest.SelectedValue = dt.Rows[0]["IsChest"].ToString();
            rbtElse.SelectedValue = dt.Rows[0]["IsElse"].ToString();
            rbtOther.SelectedValue = dt.Rows[0]["IsOther"].ToString();
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string str = "";

        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT id  FROM bb_BloodTransfusion where TransactionID='" + ViewState["TID"].ToString() + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                str = " Update bb_BloodTransfusion Set Quantity_Given='" + lblQuantity.Text + "',BloodBank_No='" + lblBBankNo.Text + "',GroupAndRh='" + lblGroup.Text + "',Temparature_Before='" + txtTemBefor.Text + "',Temparature_During='" + txtTemDuring.Text + "',Temparature_After='" + txtTemAfter.Text + "',Pulse_Before='" + txtPulseBefore.Text + "' ,Pulse_During='" + txtPulseDuring.Text + "',";
                str += "Pulse_After='" + txtPulseAfter.Text + "',BloodPressure_Before='" + txtBloodBefore.Text + "', BloodPressure_During='" + txtBloodDuring.Text + "' ,BloodPressure_After='" + txtBloodAfter.Text + "',IsChill=" + Util.GetInt(rbtChills.SelectedItem.Value) + ",IsRigor=" + Util.GetInt(rbtRigor.SelectedItem.Value) + ",IsRashes=" + Util.GetInt(rbtRash.SelectedItem.Value) + " , IsPainBack=" + Util.GetInt(rbtPain.SelectedItem.Value) + ",";
                str += "IsHead=" + Util.GetInt(rbtHead.SelectedItem.Value) + ",IsChest=" + Util.GetInt(rbtChest.SelectedItem.Value) + ",IsElse=" + Util.GetInt(rbtElse.SelectedItem.Value) + ",IsHaemoglobin=" + Util.GetInt(rbtHaemo.SelectedItem.Value) + ",IsPulmonry=" + Util.GetInt(rbtPolmonary.SelectedItem.Value) + ",IsJuandice=" + Util.GetInt(rbtJaundice.SelectedItem.Value) + ",IsOther=" + Util.GetInt(rbtOther.SelectedItem.Value) + ",UpdatedBy='" + ViewState["UserID"].ToString() + "',UpdatedDate='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "' where TransactionID='" + ViewState["TID"].ToString() + "' AND BatchNo='" + ddlBatchNo.SelectedItem.Value + "' ";


            }
            else
            {
                str = "INSERT INTO bb_BloodTransfusion(PatientID,TransactionID,Quantity_Given,BloodBank_No,GroupAndRh,BatchNo,Temparature_Before,Temparature_During,Temparature_After,";
                str += "Pulse_Before,Pulse_During,Pulse_After,BloodPressure_Before,BloodPressure_During,BloodPressure_After,IsChill,IsRigor,IsRashes,IsPainBack,";
                str += "IsHead,IsChest,IsElse,IsHaemoglobin,IsPulmonry,IsJuandice,IsOther,CreatedBy,CreatedDate) Values";
                str += "('" + ViewState["PID"].ToString() + "','" + ViewState["TID"].ToString() + "','" + lblQuantity.Text + "','" + lblBBankNo.Text + "','" + lblGroup.Text + "','" + ddlBatchNo.SelectedItem.Value + "','" + txtTemBefor.Text + "','" + txtTemDuring.Text + "','" + txtTemAfter.Text + "',";
                str += " '" + txtPulseBefore.Text + "','" + txtPulseDuring.Text + "','" + txtPulseAfter.Text + "','" + txtBloodBefore.Text + "','" + txtBloodDuring.Text + "','" + txtBloodAfter.Text + "'," + Util.GetInt(rbtChills.SelectedItem.Value) + "," + Util.GetInt(rbtRigor.SelectedItem.Value) + "," + Util.GetInt(rbtRash.SelectedItem.Value) + "," + Util.GetInt(rbtPain.SelectedItem.Value) + ",";
                str += "" + Util.GetInt(rbtHead.SelectedItem.Value) + "," + Util.GetInt(rbtChest.SelectedItem.Value) + "," + Util.GetInt(rbtElse.SelectedItem.Value) + "," + Util.GetInt(rbtHaemo.SelectedItem.Value) + "," + Util.GetInt(rbtPolmonary.SelectedItem.Value) + "," + Util.GetInt(rbtJaundice.SelectedItem.Value) + "," + Util.GetInt(rbtOther.SelectedItem.Value) + ",'" + ViewState["UserID"].ToString() + "','" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "' )";
            }

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            Tnx.Commit();
            lblMg.Text = "Record Saved Successfully";
            search(ddlBatchNo.SelectedItem.Value);

        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            lblMg.Text = "Error occurred, Please contact administrator";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }

        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    private void ClearData()
    {
        lblQuantity.Text = ""; lblBBankNo.Text = ""; lblGroup.Text = ""; txtTemBefor.Text = ""; txtTemDuring.Text = ""; txtTemAfter.Text = ""; txtBloodAfter.Text = ""; txtBloodBefore.Text = ""; txtBloodDuring.Text = ""; txtPulseDuring.Text = ""; txtPulseBefore.Text = ""; txtPulseAfter.Text = "";
        rbtHead.SelectedValue = "0";
        rbtChest.SelectedValue = "0"; rbtRash.SelectedValue = "0"; rbtPolmonary.SelectedValue = "0"; rbtChills.SelectedValue = "0"; rbtRigor.SelectedValue = "0"; rbtJaundice.SelectedValue = "0"; rbtOther.SelectedValue = "0";
        rbtPain.SelectedValue = "0"; rbtElse.SelectedValue = "0"; rbtHaemo.SelectedValue = "0";
    }






    //StringBuilder sb = new StringBuilder();
    //sb.Append("SELECT  Temparature_Before,Temparature_During,Temparature_After,Pulse_Before,Pulse_During,Pulse_After,BloodPressure_Before, BloodPressure_During ,BloodPressure_After,IsChill,IsRigor,IsRashes , IsPainBack, IsHead,IsChest,IsElse,IsHaemoglobin,IsPulmonry,IsJuandice,IsOther  FROM bb_BloodTransfusion where TransactionID='" + ViewState["TID"].ToString() + "' AND  BatchNo='" + ddlBatchNo.SelectedItem.Text + "'  ");
    ////   sb.Append("SELECT Quantity_Given,BloodBank_No,GroupAndRh,Temparature_Before,Temparature_During,Temparature_After,Pulse_Before,Pulse_During,Pulse_After,BloodPressure_Before, BloodPressure_During ,BloodPressure_After,IsChill,IsRigor,IsRashes , IsPainBack, IsHead,IsChest,IsElse,IsHaemoglobin,IsPulmonry,IsJuandice,IsOther  FROM bb_BloodTransfusion ORDER BY id DESC LIMIT 1");
    //DataTable dt = StockReports.GetDataTable(sb.ToString());
    //if (dt.Rows.Count > 0)
    //{
    //    //txtBBankNo.Text = dt.Rows[0]["BloodBank_No"].ToString();
    //    //txtGroup.Text = dt.Rows[0]["GroupAndRh"].ToString();
    //    //txtQuantity.Text = dt.Rows[0]["Quantity_Given"].ToString();
    //    txtTemBefor.Text = dt.Rows[0]["Temparature_Before"].ToString();
    //    txtTemDuring.Text = dt.Rows[0]["Temparature_During"].ToString();
    //    txtTemAfter.Text = dt.Rows[0]["Temparature_After"].ToString();
    //    txtPulseBefore.Text = dt.Rows[0]["Pulse_Before"].ToString();
    //    txtPulseDuring.Text = dt.Rows[0]["Pulse_During"].ToString();
    //    txtPulseAfter.Text = dt.Rows[0]["Pulse_After"].ToString();
    //    txtBloodBefore.Text = dt.Rows[0]["BloodPressure_Before"].ToString();
    //    txtBloodDuring.Text = dt.Rows[0]["BloodPressure_During"].ToString();
    //    txtBloodAfter.Text = dt.Rows[0]["BloodPressure_After"].ToString();
    //    rbtChills.SelectedValue = dt.Rows[0]["IsChill"].ToString();
    //    rbtRigor.SelectedValue = dt.Rows[0]["IsRigor"].ToString();
    //    rbtRash.SelectedValue = dt.Rows[0]["IsRashes"].ToString();
    //    rbtPolmonary.SelectedValue = dt.Rows[0]["IsPulmonry"].ToString();
    //    rbtPain.SelectedValue = dt.Rows[0]["IsPainBack"].ToString();
    //    rbtJaundice.SelectedValue = dt.Rows[0]["IsJuandice"].ToString();
    //    rbtHead.SelectedValue = dt.Rows[0]["IsHead"].ToString();
    //    rbtHaemo.SelectedValue = dt.Rows[0]["IsHaemoglobin"].ToString();
    //    rbtChest.SelectedValue = dt.Rows[0]["IsChest"].ToString();
    //    rbtElse.SelectedValue = dt.Rows[0]["IsElse"].ToString();
    //    rbtOther.SelectedValue = dt.Rows[0]["IsOther"].ToString();
    //}
    protected void ddlBatchNo_SelectedIndexChanged(object sender, EventArgs e)
    {
        search(ddlBatchNo.SelectedItem.Value);
    }

}