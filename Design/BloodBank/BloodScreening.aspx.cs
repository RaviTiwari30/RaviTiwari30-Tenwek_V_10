using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_BloodScreening : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string CentreID = Session["CentreID"].ToString();
            string ScreeningId = Util.GetString(StockReports.ExecuteScalar("SELECT bb_id_master('" + CentreID + "','SCR')"));

            BloodScreening bsc = new BloodScreening(tranX);

            string RequestStr = "";
            int IsApproved = 1;
            foreach (GridViewRow gr in grvListForm.Rows)
            {
                if (((CheckBox)gr.FindControl("chkTest")).Checked)
                {
                    if (RequestStr == "")
                    {
                        bsc.BloodCollection_Id = lblBloodcollectionid1.Text;
                        bsc.Method = ((DropDownList)gr.FindControl("ddlMethod")).SelectedItem.Text;
                        bsc.MethodID = Util.GetInt(((DropDownList)gr.FindControl("ddlMethod")).SelectedItem.Value);
                        bsc.Result = ((DropDownList)gr.FindControl("ddlResult")).SelectedItem.Text;
                        bsc.ResultID = Util.GetInt(((DropDownList)gr.FindControl("ddlResult")).SelectedItem.Value);
                        bsc.TestName = ((Label)gr.FindControl("lblGrdTestId")).Text;
                        bsc.value = ((TextBox)gr.FindControl("txtValue")).Text;
                        bsc.IsApproved = IsApproved;
                        if (Util.GetInt(lblIsApproved1.Text) == 4)
                        {
                            bsc.ResultStep = Util.GetInt(lblResultStep1.Text) + 1;
                        }
                        else
                            bsc.ResultStep = 0;
                        bsc.CreatedBy = Session["ID"].ToString();
                        bsc.ScreeningId = ScreeningId;
                        bsc.CentreID = Util.GetInt(Session["Centre"].ToString());
                        //bsc.ResultStep = 0;
                        bsc.Insert();
                    }
                    else
                    {
                        bsc.BloodCollection_Id = lblBloodcollectionid1.Text;
                        bsc.Method = ((DropDownList)gr.FindControl("ddlMethod")).SelectedItem.Text;
                        bsc.MethodID = Util.GetInt(((DropDownList)gr.FindControl("ddlMethod")).SelectedItem.Value);
                        bsc.Result = ((DropDownList)gr.FindControl("ddlResult")).SelectedItem.Text;
                        bsc.ResultID = Util.GetInt(((DropDownList)gr.FindControl("ddlResult")).SelectedItem.Value);
                        bsc.TestName = ((Label)gr.FindControl("lblGrdTestId")).Text;
                        bsc.value = ((TextBox)gr.FindControl("txtValue")).Text;
                        bsc.IsApproved = IsApproved;
                        bsc.CreatedBy = Session["ID"].ToString();
                        bsc.ScreeningId = ScreeningId;
                        bsc.CentreID = Util.GetInt(Session["Centre"].ToString());
                        bsc.Insert();
                    }
                }
            }
            if (lblScreeningID.Text != "")
            {
                string TestName = "SELECT TestName FROM bb_blood_screening WHERE Screening_Id='" + lblScreeningID.Text + "' AND IsApproved=4";
                DataTable dt2 = StockReports.GetDataTable(TestName.ToString());
                for (int s = 0; s < dt2.Rows.Count; s++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE bb_blood_screening  SET IsApproved=3,IsActive=0 WHERE Screening_Id='" + lblScreeningID.Text + "' and TestName='" + dt2.Rows[s]["TestName"].ToString() + "'");
                }
            }
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE	bb_visitors_history SET Isscreened=1 where BloodCollection_ID='" + ViewState["BloodCollectionID"].ToString() + "' ");

            tranX.Commit();
           
            search();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }

    protected void grdDonor_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AResult")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            lblDonerID1.Text = ((Label)grdDonor.Rows[index].FindControl("lblDonorID")).Text;
            lblBloodcollectionid1.Text = ((Label)grdDonor.Rows[index].FindControl("lblBloodcollectionid")).Text;

            lblName1.Text = ((Label)grdDonor.Rows[index].FindControl("lblName")).Text;
            lblGroup1.Text = ((Label)grdDonor.Rows[index].FindControl("lblGroup")).Text;
            lblDonationDate1.Text = ((Label)grdDonor.Rows[index].FindControl("lblDonationDate")).Text;
            lblVisitID1.Text = ((Label)grdDonor.Rows[index].FindControl("lblVisitID")).Text;
            lblTubeNo1.Text = ((Label)grdDonor.Rows[index].FindControl("lblTubeNo")).Text;
            lblBagType1.Text = ((Label)grdDonor.Rows[index].FindControl("lblBagType")).Text;
            lblVolumn1.Text = ((Label)grdDonor.Rows[index].FindControl("lblVolumn")).Text;
            lblResultStep1.Text = ((Label)grdDonor.Rows[index].FindControl("lblResultStep")).Text;
            lblIsApproved1.Text = ((Label)grdDonor.Rows[index].FindControl("lblIsApproved")).Text;
            lblScreeningID.Text = ((Label)grdDonor.Rows[index].FindControl("lblScreeningID")).Text;
            var BagStatus = ((Label)grdDonor.Rows[index].FindControl("lblBagStatus")).Text;

            ViewState["BloodCollectionID"] = lblBloodcollectionid1.Text;
            mpeCreateGroup.Show();
            if (lblScreeningID.Text != "" && BagStatus == "2")// Only Repeat
            {
                ReTestCases(lblBloodcollectionid1.Text);
            }
            else
            {
                BindGrid(lblBloodcollectionid1.Text);
            }
        }
    }

    private void ReTestCases(string BagNo)
    {

        DataTable dtDonorRecord = new DataTable();
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT TestName FROM bb_blood_screening WHERE Screening_Id='" + lblScreeningID.Text + "' AND IsApproved=4  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        StringBuilder sb1 = new StringBuilder();
        string testid = "";
        for (int l = 0; l < dt.Rows.Count; l++)
        {
            if (testid == "")
            { testid = "'" + dt.Rows[l]["TestName"].ToString() + "'"; }
            else
            {
                testid = testid + ",'" + dt.Rows[l]["TestName"].ToString() + "'";
            }

        }

        StringBuilder sb2 = new StringBuilder();
        sb2.Append(" SELECT md.reading as Value,md.Test_ID AS TestName,'' MethodID, ");
        sb2.Append(" CASE WHEN reading2<>'' THEN reading2 WHEN reading1<>'' THEN md.reading WHEN md.reading1<>'' THEN ");
        sb2.Append(" CASE WHEN md.Reading<0.900 THEN '4' ");
        sb2.Append(" WHEN  md.reading>'0.900' and  md.reading<'1' THEN '6' ELSE 5 END ");
        sb2.Append(" ELSE  CASE WHEN md.Reading<0.900 THEN '4' ");
        sb2.Append(" WHEN  md.reading>'0.900' and  md.reading<'1' THEN '6' ELSE 5 END ");
        sb2.Append(" END ResultID,'' BagConditionatResult FROM mac_Data md WHERE md.labno='" + BagNo + "' and md.Test_ID in(" + testid + ")");
        dtDonorRecord = StockReports.GetDataTable(sb2.ToString());


        sb1.Append("SELECT Id,TestName,'" + lblBloodcollectionid1.Text + "' Bloodcollection_id,if(Value=1,'true','false')Value,");
        sb1.Append(" Method,Result,'' DefaultMethodName FROM bb_BloodTests_master WHERE IsActive=1");

        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt1.Rows.Count > 0)
        {
            grvListForm.DataSource = dt1;
            grvListForm.DataBind();
            BindMethod();
            BindResult();
            int i = dt.Rows.Count;

            int j = 0;
            while (j < i)
            {
                int k = Convert.ToInt32(dt.Rows[j]["TestName"]) - 1;
                ((CheckBox)grvListForm.Rows[k].FindControl("chkTest")).Checked = true;


                ((CheckBox)grvListForm.Rows[k].FindControl("chkTest")).Enabled = false;
                if (dtDonorRecord.Rows.Count > 0)
                {
                    ((TextBox)grvListForm.Rows[j].FindControl("txtValue")).Text = Util.GetString(dtDonorRecord.Rows[j]["Value"]);
                    ((DropDownList)grvListForm.Rows[j].FindControl("ddlResult")).SelectedIndex = ((DropDownList)grvListForm.Rows[j].FindControl("ddlResult")).Items.IndexOf(((DropDownList)grvListForm.Rows[j].FindControl("ddlResult")).Items.FindByValue(Util.GetString(dtDonorRecord.Rows[j]["ResultID"])));
                }

                if (dt1.Rows[k]["Method"].ToString() == "0")

                    ((DropDownList)grvListForm.Rows[k].FindControl("ddlMethod")).Visible = false;
                if (dt1.Rows[k]["Result"].ToString() == "0")
                    ((DropDownList)grvListForm.Rows[k].FindControl("ddlResult")).Visible = false;
                j++;
            }
        }
        foreach (GridViewRow gr in grvListForm.Rows)
        {
            if (!((CheckBox)gr.FindControl("chkTest")).Checked)
            {
                gr.Visible = false;
            }
        }
    }
    private void BindGrid(string BagNo)
    {
        StringBuilder sb1 = new StringBuilder();

        DataTable dtDonorRecord = StockReports.GetDataTable("SELECT `Value`,TestName,MethodID,ResultID,'' BagConditionatResult	 FROM bb_blood_screening WHERE BloodCollection_Id='" + BagNo + "' ");

        if (dtDonorRecord.Rows.Count <= 0)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT md.reading as Value,md.Test_ID AS TestName,'' MethodID, ");
            sb.Append(" CASE WHEN reading2<>'' THEN reading2 WHEN reading1<>'' THEN md.reading WHEN md.reading1<>'' THEN ");
            sb.Append(" CASE WHEN md.Reading<0.900 THEN '4' ");
            sb.Append(" WHEN  md.reading>'0.900' OR  md.reading<'1' THEN '6' ELSE 5 END ");
            sb.Append(" ELSE  CASE WHEN md.Reading<0.900 THEN '4' ");
            sb.Append(" WHEN  md.reading>'0.900' and  md.reading<'1' THEN '6' ELSE 5 END ");
            sb.Append(" END ResultID,'' BagConditionatResult FROM mac_Data md WHERE md.labno='" + BagNo + "' ");
            dtDonorRecord = StockReports.GetDataTable(sb.ToString());
        }

        sb1.Append("SELECT Id,TestName,'" + lblBloodcollectionid1.Text + "' Bloodcollection_id,if(Value=1,'true','false')Value,");
        sb1.Append(" Method,Result,'' DefaultMethodName FROM bb_BloodTests_master WHERE IsActive=1");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt1.Rows.Count > 0)
        {
            grvListForm.DataSource = dt1;
            grvListForm.DataBind();
            BindMethod();
            BindResult();
            int i = dt1.Rows.Count;
            int j = 0;
            while (j < i)
            {
                ((CheckBox)grvListForm.Rows[j].FindControl("chkTest")).Checked = true;
                ((CheckBox)grvListForm.Rows[j].FindControl("chkTest")).Enabled = false;
                //if (dt1.Rows[j]["Method"].ToString() == "0")
                //    ((DropDownList)grvListForm.Rows[j].FindControl("ddlMethod")).Visible = false;
                //if (dt1.Rows[j]["Result"].ToString() == "0")
                //    ((DropDownList)grvListForm.Rows[j].FindControl("ddlResult")).Visible = false;
                //    ((DropDownList)grvListForm.Rows[j].FindControl("ddlMethod")).SelectedItem.Text = ;
                ((DropDownList)grvListForm.Rows[j].FindControl("ddlMethod")).SelectedIndex = ((DropDownList)grvListForm.Rows[j].FindControl("ddlMethod")).Items.IndexOf(((DropDownList)grvListForm.Rows[j].FindControl("ddlMethod")).Items.FindByText(Util.GetString(((Label)grvListForm.Rows[j].FindControl("lblDefaultMethodName")).Text)));
                j++;
            }

            for (int a = 0; a < dtDonorRecord.Rows.Count; a++)
            {
                for (int b = 0; b < grvListForm.Rows.Count; b++)
                {
                    if (Util.GetString(dtDonorRecord.Rows[a]["TestName"]) == Util.GetString(((Label)grvListForm.Rows[b].FindControl("lblGrdTestId")).Text))
                    {
                        ((DropDownList)grvListForm.Rows[b].FindControl("ddlMethod")).SelectedIndex = ((DropDownList)grvListForm.Rows[b].FindControl("ddlMethod")).Items.IndexOf(((DropDownList)grvListForm.Rows[b].FindControl("ddlMethod")).Items.FindByValue(Util.GetString(dtDonorRecord.Rows[a]["MethodID"])));
                        ((TextBox)grvListForm.Rows[b].FindControl("txtValue")).Text = Util.GetString(dtDonorRecord.Rows[a]["Value"]);
                        ((DropDownList)grvListForm.Rows[b].FindControl("ddlResult")).SelectedIndex = ((DropDownList)grvListForm.Rows[b].FindControl("ddlResult")).Items.IndexOf(((DropDownList)grvListForm.Rows[b].FindControl("ddlResult")).Items.FindByValue(Util.GetString(dtDonorRecord.Rows[a]["ResultID"])));
                    }
                }
            }
           
        }
    }
    protected void grvListForm_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Attributes["onmouseover"] = "javascript:SetMouseOver(this)";
            e.Row.Attributes["onmouseout"] = "javascript:SetMouseOut(this)";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodgroup);
            ddlBloodgroup.Items.Insert(0, new ListItem("Select", "0"));
            txtcollectfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtcollectTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            txtCollectionId.Text = string.Empty;
            txtCollectionId.Focus();
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
        }
        txtcollectfrom.Attributes.Add("readOnly", "true");
        txtcollectTo.Attributes.Add("readOnly", "true");
    }

    private void BindGrid()
    {
        StringBuilder sb1 = new StringBuilder();

        sb1.Append("SELECT Id,TestName,'" + lblBloodcollectionid1.Text + "' Bloodcollection_id,if(Value=1,'true','false')Value,");
        sb1.Append(" Method,Result FROM bb_BloodTests_master WHERE IsActive=1");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt1.Rows.Count > 0)
        {
            grvListForm.DataSource = dt1;
            grvListForm.DataBind();
            BindMethod();
            BindResult();
            int i = dt1.Rows.Count;
            int j = 0;
            while (j < i)
            {
                ((CheckBox)grvListForm.Rows[j].FindControl("chkTest")).Checked = true;
                ((CheckBox)grvListForm.Rows[j].FindControl("chkTest")).Enabled = false;
                if (dt1.Rows[j]["Method"].ToString() == "0")

                    ((DropDownList)grvListForm.Rows[j].FindControl("ddlMethod")).Visible = false;
                if (dt1.Rows[j]["Result"].ToString() == "0")
                    ((DropDownList)grvListForm.Rows[j].FindControl("ddlResult")).Visible = false;

                j++;
            }
        }
    }

    private void BindMethod()
    {
        DataTable dt1 = StockReports.GetDataTable("SELECT ID,Method FROM bb_Method_Master where IsActive=1 order by ID");

        for (int i = 0; i < grvListForm.Rows.Count; i++)
        {
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlMethod")).DataSource = dt1;
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlMethod")).DataTextField = "Method";
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlMethod")).DataValueField = "ID";
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlMethod")).DataBind();
        }
    }

    private void BindResult()
    {
        DataTable dt1 = StockReports.GetDataTable("SELECT ID,Result FROM bb_Result_Master where IsActive=1 order by ID");

        for (int i = 0; i < grvListForm.Rows.Count; i++)
        {
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlResult")).DataSource = dt1;
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlResult")).DataTextField = "Result";
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlResult")).DataValueField = "ID";
            ((DropDownList)grvListForm.Rows[i].FindControl("ddlResult")).DataBind();
        }
    }

    private void ReTestCases()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT TestName FROM bb_blood_screening WHERE Screening_Id='" + lblScreeningID.Text + "' AND IsApproved=4  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        StringBuilder sb1 = new StringBuilder();

        sb1.Append("SELECT Id,TestName,'" + lblBloodcollectionid1.Text + "' Bloodcollection_id,if(Value=1,'true','false')Value,");
        sb1.Append(" Method,Result FROM bb_BloodTests_master WHERE IsActive=1");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt1.Rows.Count > 0)
        {
            grvListForm.DataSource = dt1;
            grvListForm.DataBind();
            BindMethod();
            BindResult();
            int i = dt.Rows.Count;

            int j = 0;
            while (j < i)
            {
                int k = Convert.ToInt32(dt.Rows[j]["TestName"]) - 1;
                ((CheckBox)grvListForm.Rows[k].FindControl("chkTest")).Checked = true;
                ((CheckBox)grvListForm.Rows[k].FindControl("chkTest")).Enabled = false;
                if (dt1.Rows[k]["Method"].ToString() == "0")

                    ((DropDownList)grvListForm.Rows[k].FindControl("ddlMethod")).Visible = false;
                if (dt1.Rows[k]["Result"].ToString() == "0")
                    ((DropDownList)grvListForm.Rows[k].FindControl("ddlResult")).Visible = false;
                j++;
            }
        }
        foreach (GridViewRow gr in grvListForm.Rows)
        {
            if (!((CheckBox)gr.FindControl("chkTest")).Checked)
            {
                gr.Visible = false;
            }
        }
    }

    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DISTINCT(bs.Screening_Id), if((bcd.isdonated=1 AND bvh.IsScreened=0),'1',if((bs.IsApproved=4 AND bvh.IsScreened=4 ),'2',IF((bcd.isdonated=1 AND bvh.IsScreened=3 AND bs.IsApproved=1),'4','3')))BagStatus,bv.Visitor_ID,bv.name,bvh.Visit_ID,bcd.Bloodcollection_id,bv.Gender,bbg.BGTested as BloodGroup,DATE_FORMAT(bcd.Collecteddate,'%d-%b-%Y')Collecteddate,bcd.bbtubeNo,bcd.bagType,bcd.volume,bs.ResultStep,bs.IsApproved FROM  ");
            sb.Append(" bb_visitors bv INNER JOIN bb_visitors_history bvh ON bvh.Visitor_ID=bv.Visitor_ID INNER JOIN bb_collection_details bcd ON bcd.Visitor_Id =bv.Visitor_Id and bcd.visit_id=bvh.visit_id");
            sb.Append(" INNER JOIN bb_grouping  bbg ON  bbg.BloodCollection_ID = bcd.BloodCollection_Id LEFT JOIN bb_bloodgroup_master bgm ON bgm.id=bv.BloodGroup_Id ");
            sb.Append(" LEFT OUTER JOIN bb_blood_screening bs ON bs.BloodCollection_Id=bcd.BloodCollection_Id ");
            sb.Append(" WHERE  ((bcd.isdonated=1 AND bvh.IsScreened=0) OR (bs.IsApproved=4 AND bvh.IsScreened=4 )) AND bv.CentreID=" + Util.GetInt(ViewState["CenterID"]) + " ");
            if (txtDonorId.Text != "")
            {
                sb.Append(" and bv.Visitor_ID='" + txtDonorId.Text + "'");
            }
            if (txtCollectionId.Text != "")
            {
                sb.Append(" and bcd.Bloodcollection_id ='" + txtCollectionId.Text + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" and bv.name like '" + txtName.Text.Trim() + "%'");
            }
            if (ddlBloodgroup.SelectedIndex != 0)
            {
                sb.Append(" and bgm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
            }
            if (txtDonorId.Text == "" && txtCollectionId.Text == "" && txtName.Text == "" && ddlBloodgroup.SelectedIndex == 0)
            {
                if (txtcollectfrom.Text != "")
                {
                    sb.Append("AND DATE(bcd.Collecteddate)>='" + Util.GetDateTime(txtcollectfrom.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (txtcollectTo.Text != "")
                {
                    sb.Append(" and DATE(bcd.Collecteddate)<='" + Util.GetDateTime(txtcollectTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdDonor.DataSource = dt;
                grdDonor.DataBind();
                pnlHide.Visible = true;
            }
            else
            {
                grdDonor.DataSource = dt;
                grdDonor.DataBind();
                pnlHide.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);

            grdDonor.DataSource = null;
            grdDonor.DataBind();
            pnlHide.Visible = false;
        }
    }
}