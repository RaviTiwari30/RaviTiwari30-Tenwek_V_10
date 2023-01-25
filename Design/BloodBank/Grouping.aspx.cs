using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_Grouping : System.Web.UI.Page
{
    protected void btnCancel_Click(object sender, EventArgs e)
    {
    }

    protected void btnOk_Click(object sender, EventArgs e)
    {
        grdGrouping.Visible = true;
        grdBloodMatch.Visible = false;
        grdResult.Visible = false;
        btnOk.Visible = false;
        search();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {


        search();
        grdGrouping.Visible = true;
        grdBloodMatch.Visible = false;
        grdResult.Visible = false;
        btnOk.Visible = false;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        SaveRecord();
        search();
        grdBloodMatch.Visible = true;
    }

    protected void grdBloodMatch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
    }

    protected void grdGrouping_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        grdBloodMatch.Visible = true;
        if (e.CommandName == "AStatus")
        {
            int index = Convert.ToInt32((e.CommandArgument));
            Label visitor = ((Label)grdGrouping.Rows[index].FindControl("lblID"));
            string visitors_id = Util.GetString(visitor.Text).ToString();
            lblvisitors_id.Text = visitors_id;
            lblIndex.Text = index.ToString();
            lblId.Text = "0";

            Data();
            match();
            match1();
        }
        if (e.CommandName == "ASample")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            lblIndex.Text = index.ToString();
            lblId.Text = "1";
            Data();
        }
        if (e.CommandName == "AHistory")
        {
            int index = Convert.ToInt32((e.CommandArgument));
            string DonationId = ((Label)grdGrouping.Rows[index].FindControl("lblCollectionID")).Text;
            StringBuilder sb = new StringBuilder();
            sb.Append("Select Grouping_Id,BloodCollection_Id,CASE WHEN LedgerType=4 THEN (CASE WHEN IsMType=2 THEN 'Mother' ELSE 'Baby' END) ELSE (CASE WHEN LedgerType=2 THEN 'Patient' ELSE 'Donor' END) END AS Sample,CASE WHEN (AntiA=1) THEN 'N' ELSE 'P' END  AntiA, ");
            sb.Append(" CASE WHEN (AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,CASE WHEN (RH=1) THEN 'N' ELSE 'P' END AS RH, ");
            sb.Append(" CASE WHEN (ACell=1) THEN 'N' ELSE 'P' END AS ACell,CASE WHEN (BCell=1) THEN 'N' ELSE 'P' END AS BCell,");
            sb.Append(" CASE WHEN (OCell=1) THEN 'N' ELSE 'P' END AS OCell,BloodGroupAlloted");
            sb.Append(" ,BloodTested,CASE WHEN (IsSame=0) THEN 'No' ELSE 'Yes' END AS IsSame,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate from bb_Grouping where BloodCollection_Id='" + DonationId + "'");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                panelbloodmatch.Visible = true;
                grdBloodMatch.DataSource = dt;
                grdBloodMatch.DataBind();
            }
            else
            {
                panelbloodmatch.Visible = false;
                grdBloodMatch.DataSource = null;
                grdBloodMatch.DataBind();
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodgroup);
            ddlBloodgroup.Items.Insert(0, new ListItem("Select", "0"));
            txtdonationfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdonationTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            txtDonationId.Text = string.Empty;
            txtDonationId.Focus();
            caldonationfrom.EndDate = DateTime.Now;
            caldonationTo.EndDate = DateTime.Now;
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
        }
        txtdonationfrom.Attributes.Add("readOnly", "true");
        txtdonationTo.Attributes.Add("readOnly", "true");
    }

    protected void SaveRecord()
    {

        string selectedBloodGroup = ddlBloodGroupNew.SelectedValue + "" + ddlRh.SelectedValue;
        string AntiA, AntiB, AntiAB, RH, ACell, BCell, OCell;

        //-------Start Reverse Blood Group MAtch accrording to blood group------

        DataTable dtbgMatch = StockReports.GetDataTable(" SELECT AntiA,AntiB,AntiAB,RH from bb_BloodMatch_master where BloodAlloted='" + selectedBloodGroup + "' ");
        DataTable dtbgMatchRev = StockReports.GetDataTable("SELECT ACell,BCell,OCell from bb_BloodMatchReverse_Master where BloodGroupAlloted = '" + ddlBloodGroupNew.SelectedValue + "' ");

        AntiA = dtbgMatch.Rows[0]["AntiA"].ToString();
        AntiB = dtbgMatch.Rows[0]["AntiB"].ToString();
        AntiAB = dtbgMatch.Rows[0]["AntiAB"].ToString();
        RH = dtbgMatch.Rows[0]["RH"].ToString();
        ACell = dtbgMatchRev.Rows[0]["ACell"].ToString();
        BCell = dtbgMatchRev.Rows[0]["BCell"].ToString();
        OCell = dtbgMatchRev.Rows[0]["OCell"].ToString();


        //-----------End------------


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            BloodGrouping bg = new BloodGrouping();
            bg.CentreId = Util.GetInt(Session["CentreID"].ToString());

            bg.AntiA = AntiA;
            bg.AntiAB = AntiAB;
            bg.AntiB = AntiB;
            bg.RH = RH;
            bg.ACell = ACell;
            bg.BCell = BCell;
            bg.OCell = OCell;

            bg.CreatedBy = Session["ID"].ToString();
            bg.Status = 1;
            bg.ScreenedBG = lblGroup1.Text;
            bg.BloodCollection_Id = lblDonation1.Text;
            string GroupingId = bg.Insert();

            // MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE	bb_visitors_history SET  IsGrouped =1 where BloodCollection_Id='" + lblDonation1.Text + "' ");

        

            string str = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select BloodAlloted from bb_BloodMatch_master where AntiA=" + AntiA + "  AND AntiB=" + AntiB + " AND AntiAB=" + AntiAB + " AND RH=" + RH + " "));
            string str1 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT ScreenedBG FROM bb_Grouping WHERE Grouping_Id='" + GroupingId + "' "));

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodTested='" + str + "',IsSame= 1,IsApproved =3 where Grouping_Id='" + GroupingId + "' ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history SET  IsGrouped =3 where BloodCollection_Id='" + lblDonation1.Text + "' ");

            string j = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT IsSame FROM bb_Grouping WHERE Grouping_Id ='" + GroupingId + "' "));
            // string bloodcollection_id = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT bbgrpm.id FROM bb_Grouping grp INNER JOIN bb_bloodgroup_master bbgrpm ON bbgrpm.BloodGroup=grp.bloodtested WHERE grp.Grouping_Id ='" + GroupingId + "' "));
            //string bloodcollection_id = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT bbgrpm.BloodMasterID FROM bb_Grouping grp INNER JOIN bb_BloodMatch_master bbgrpm ON bbgrpm.BloodAlloted=grp.bloodtested WHERE grp.Grouping_Id ='" + GroupingId + "' "));

            string bloodcollection_id = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT bbgrpm.BloodMasterID FROM  bb_BloodMatch_master bbgrpm  WHERE bbgrpm.BloodAlloted ='" + str + "' "));
            string update = "UPDATE bb_visitors SET BloodGroup_Id='" + bloodcollection_id + "' where Visitor_ID='" + lblvisitors_id.Text + "' ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, update);

            string Str2 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT BloodGroupAlloted from bb_BloodMatchReverse_Master where ACell=" + ACell + " AND BCell=" + BCell + " AND OCell=" + OCell + " "));

           
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodGroupAlloted='" + Str2 + "' WHERE Grouping_Id='" + GroupingId + "' ");

            string str3 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, " SELECT BGGroup from bb_BloodMatch_master where AntiA =" + AntiA + " AND AntiB=" + AntiB + " AND AntiAB=" + AntiAB + " AND  RH=" + RH + " "));
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BGTested='" + str3 + "' Where Grouping_Id='" + GroupingId + "' ");

            Tranx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);

            StringBuilder sb2 = new StringBuilder();
            sb2.Append(" Select Grouping_Id,BloodCollection_Id,'' AS Sample,CASE WHEN (AntiA=1) THEN 'N' ELSE 'P' END  AS AntiA,  ");
            sb2.Append(" CASE WHEN (AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,");
            sb2.Append(" CASE WHEN (RH=1) THEN 'N'  WHEN (RH=3) THEN 'WP' else 'N' END AS RH,CASE WHEN (ACell=1) THEN 'N' ELSE 'P' END AS ACell,CASE WHEN (BCell=1) THEN 'N' ELSE 'P' END AS BCell,");
            sb2.Append(" CASE WHEN (OCell=1) THEN 'N' ELSE 'P' END AS OCell,BloodGroupAlloted,");
            sb2.Append(" BloodTested,CASE WHEN (IsSame=0) THEN 'No' ELSE 'Yes' END AS IsSame,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate from bb_Grouping where Grouping_Id = '" + GroupingId + "' ");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            grdBloodMatch.Columns[2].Visible = false;
            grdBloodMatch.Columns[10].Visible = true;
            grdResult.Visible = false;
            if (dt.Rows.Count > 0)
            {
                grdBloodMatch.DataSource = dt;
                grdBloodMatch.DataBind();
                panelbloodmatch.Visible = true;
            }
            else
            {
                grdBloodMatch.DataSource = null;
                grdBloodMatch.DataBind();
                panelbloodmatch.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            search();
        }
    }

    private void BindDetail()
    {
    }

    private void Data()
    {
        int i = Convert.ToInt32(lblIndex.Text);
        lblDonation1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblCollectionID")).Text;
        lblName1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblName")).Text;
        lblGroup1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblGroup")).Text;

        DataTable dt = StockReports.GetDataTable("select InvestigationID,Name from bb_Investigation_Master where IsActive=1");
        dtInvestigation.DataSource = dt;
        dtInvestigation.DataBind();


        //---Bind blood Group and RH

        DataTable dtBG = StockReports.GetDataTable("SELECT DISTINCT BloodAlloted FROM bb_bloodgroup_master WHERE isActive=1 AND BloodAlloted IS NOT NULL;");

        ddlBloodGroupNew.DataSource = dtBG;
        ddlBloodGroupNew.DataTextField = "BloodAlloted";
        ddlBloodGroupNew.DataValueField = "BloodAlloted";
        ddlBloodGroupNew.DataBind();


        //--



        mpeCreateGroup.Show();
    }

    private void match()
    {
        //DataTable dt = StockReports.GetDataTable("Select bloodMasterID,AntiA,AntiA1,AntiB,AntiAB,AntiD,BloodAlloted,BgGroup from bb_bloodmatch_master  where ISActive=1");
        StringBuilder sb2 = new StringBuilder();
        sb2.Append(" Select bloodMasterID,CASE WHEN (AntiA=1) THEN 'N' ELSE 'P' END AS AntiA, ");
        sb2.Append(" CASE WHEN (AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,");
        sb2.Append(" CASE WHEN (RH=1) THEN 'N' ELSE 'P' END AS RH,BloodAlloted,BgGroup from bb_bloodmatch_master  where ISActive=1 ");
        gridmatch.DataSource = StockReports.GetDataTable(sb2.ToString());
        gridmatch.DataBind();
    }

    private void match1()
    {
        StringBuilder sb3 = new StringBuilder();
        //DataTable dt = StockReports.GetDataTable("Select ID,ACell,BCell,OCell,BloodGroupAlloted from bb_bloodmatchreverse_master  where ISActive=1");
        sb3.Append(" Select ID,CASE WHEN (ACell=1) THEN 'N' ELSE 'P' END AS ACell,CASE WHEN (BCell=1) THEN 'N' ELSE 'P' END AS BCell,");
        sb3.Append(" CASE WHEN (OCell=1) THEN 'N' ELSE 'P' END AS OCell, ");
        sb3.Append(" BloodGroupAlloted from bb_bloodmatchreverse_master  where ISActive=1 ");
        grdMatch1.DataSource = StockReports.GetDataTable(sb3.ToString());
        grdMatch1.DataBind();
    }

    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT  bv.Visitor_ID,bv.name,bcd.Bloodcollection_id,bv.dtBirth,bv.Gender,bgm.BloodGroup,DATE_FORMAT(bcd.Collecteddate,'%d-%b-%Y')Collecteddate FROM  ");
            sb.Append(" bb_visitors bv INNER JOIN bb_visitors_history bvh ON bvh.Visitor_ID=bv.Visitor_ID INNER JOIN bb_collection_details bcd ON bcd.Visitor_Id =bv.Visitor_Id AND bvh.visit_id=bcd.visit_id");
            sb.Append("   LEFT JOIN bb_bloodgroup_master bgm ON bgm.id=bv.BloodGroup_Id WHERE bcd.isdonated=1 AND bvh.IsGrouped=0 AND bvh.CentreID=" + Util.GetInt(ViewState["CenterID"]) + " ");
            if (txtDonationId.Text != "")
            {
                sb.Append("AND bcd.Bloodcollection_id='" + txtDonationId.Text.Trim() + "'");
            }
            if (txtDonorID.Text != "")
            {
                sb.Append(" and bv.Visitor_ID='" + txtDonorID.Text.Trim() + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" AND bv.name like '%" + txtName.Text.Trim() + "%'");
            }
            if (ddlBloodgroup.SelectedIndex != 0)
            {
                sb.Append(" and bgm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
            }
            if (txtDonationId.Text == "" && txtName.Text == "" && txtDonorID.Text == "" && ddlBloodgroup.SelectedIndex == 0)
            {
                if (txtdonationfrom.Text != "")
                {
                    sb.Append(" AND DATE(bcd.Collecteddate) >='" + Util.GetDateTime(txtdonationfrom.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (txtdonationTo.Text != "")
                {
                    sb.Append(" and DATE(bcd.Collecteddate) <='" + Util.GetDateTime(txtdonationTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdGrouping.DataSource = dt;
                grdGrouping.DataBind();
                pnlhide.Visible = true;
            }
            else
            {
                grdGrouping.DataSource = null;
                grdGrouping.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                pnlhide.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            grdGrouping.DataSource = null;
            grdGrouping.DataBind();
            pnlhide.Visible = false;
        }
    }
}