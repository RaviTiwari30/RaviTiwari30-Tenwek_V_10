 using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_PatientGrouping : System.Web.UI.Page
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
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();  //
        grdGrouping.Visible = true;
        grdBloodMatch.Visible = false;
        grdResult.Visible = false;
        btnOk.Visible = false;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        SaveRecord();
        grdBloodMatch.Visible = true;
    }

    protected void grdBloodMatch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
    }

    protected void grdGrouping_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        grdBloodMatch.Visible = true;
        if (e.CommandName == "True")   // Age is less than 4 month 
        {
            int index = Convert.ToInt32((e.CommandArgument));
            Label visitor = ((Label)grdGrouping.Rows[index].FindControl("lblID"));
            string visitors_id = Util.GetString(visitor.Text).ToString();
            lbloldGroupID.Text = ((Label)grdGrouping.Rows[index].FindControl("lblGroupingID")).ToString();
            lblvisitors_id.Text = visitors_id;
            lblIndex.Text = index.ToString();
            lblId.Text = "0";

            Data();
            match();
            match1();
        }
        else if (e.CommandName == "False")  // Age is greater than or equal to 4 month
        {
            int index = Convert.ToInt32((e.CommandArgument));
            Label visitor = ((Label)grdGrouping.Rows[index].FindControl("lblID"));
            string visitors_id = Util.GetString(visitor.Text).ToString();
            lblvisitors_id.Text = visitors_id;
            Label oldGroupid = ((Label)grdGrouping.Rows[index].FindControl("lblGroupingID"));
            string OldGroupIDValue = Util.GetString(oldGroupid.Text);
            lbloldGroupID.Text = OldGroupIDValue;
            lblIndex.Text = index.ToString();
            lblId.Text = "0";

            Data();
            if (lblMotherID1.Text != "")
            {
                matchM();
            }
            else
            {
                match();
            }
            match1();
        }
        //if (e.CommandName == "ASample")
        //{
        //    int index = Convert.ToInt32(e.CommandArgument);
        //    lblIndex.Text = index.ToString();
        //    lblId.Text = "1";
        //    Data();
        //}
        //if (e.CommandName == "AHistory")
        //{
        //    int index = Convert.ToInt32((e.CommandArgument));
        //    string DonationId = ((Label)grdGrouping.Rows[index].FindControl("lblCollectionID")).Text;
        //    StringBuilder sb = new StringBuilder();
        //    sb.Append("Select Grouping_Id,BloodCollection_Id,CASE WHEN LedgerType=4 THEN (CASE WHEN IsMType=2 THEN 'Mother' ELSE 'Baby' END) ELSE (CASE WHEN LedgerType=2 THEN 'Patient' ELSE 'Donor' END) END AS Sample,CASE WHEN (AntiA=1) THEN 'N' ELSE 'P' END  AntiA, ");
        //    sb.Append(" CASE WHEN (AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,CASE WHEN (RH=1) THEN 'N' ELSE 'P' END AS RH, ");
        //    sb.Append(" CASE WHEN (ACell=1) THEN 'N' ELSE 'P' END AS ACell,CASE WHEN (BCell=1) THEN 'N' ELSE 'P' END AS BCell,");
        //    sb.Append(" CASE WHEN (OCell=1) THEN 'N' ELSE 'P' END AS OCell,BloodGroupAlloted");
        //    sb.Append(" ,BloodTested,CASE WHEN (IsSame=0) THEN 'No' ELSE 'Yes' END AS IsSame,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate from bb_Grouping where BloodCollection_Id='" + DonationId + "'");

        //    DataTable dt = StockReports.GetDataTable(sb.ToString());
        //    if (dt.Rows.Count > 0)
        //    {
        //        panelbloodmatch.Visible = true;
        //        grdBloodMatch.DataSource = dt;
        //        grdBloodMatch.DataBind();
        //    }
        //    else
        //    {
        //        panelbloodmatch.Visible = false;
        //        grdBloodMatch.DataSource = null;
        //        grdBloodMatch.DataBind();
        //    }
        //}
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
          //  BloodBank.bindBloodGroup(ddlBloodgroup);
            txtdonationfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdonationTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            //txtDonationId.Text = string.Empty;
            //txtDonationId.Focus();
            lblMsg.Visible = false;
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
      

        string InvesAns = "";

        foreach (DataListItem dt in dtInvestigation.Items)
        {
            if (InvesAns == "")
            {
                InvesAns = ((DropDownList)dt.FindControl("ddlInvestigation")).SelectedValue;
            }
            else
            {
                InvesAns = InvesAns + "," + ((DropDownList)dt.FindControl("ddlInvestigation")).SelectedValue;
            }
        }
        //string AntiA, AntiB, AntiAB, RH, ACell, BCell, OCell;
        //char[] separator = new char[] { ',' };
        //string[] strSplitArr = InvesAns.Split(separator);
        //AntiA = strSplitArr[0];
        //AntiB = strSplitArr[1];
        //AntiAB = strSplitArr[2];
        //RH = strSplitArr[3];
        //ACell = strSplitArr[4];
        //BCell = strSplitArr[5];
        //OCell = strSplitArr[6];

        string str7 = StockReports.ExecuteScalar(" SELECT BGGroup from bb_BloodMatch_master where AntiA =" + AntiA + "  AND AntiB=" + AntiB + " AND AntiAB=" + AntiAB + " AND  RH=" + RH + " ");
        string Str9 = StockReports.ExecuteScalar("SELECT BloodGroupAlloted from bb_BloodMatchReverse_Master where ACell=" + ACell + " AND BCell=" + BCell + " AND OCell=" + OCell + "  ");

        if (str7.ToString() != Str9.ToString())
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM217','" + lblerrMsg.ClientID + "');", true);

            mpeCreateGroup.Show();
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            //BloodGrouping bg = new BloodGrouping();
            //bg.CentreId = Util.GetInt(Session["centre"].ToString());

            //bg.AntiA = AntiA;
            //bg.AntiAB = AntiAB;
            //bg.AntiB = AntiB;
            //bg.RH = RH;
            //bg.ACell = ACell;
            //bg.BCell = BCell;
            //bg.OCell = OCell;

            //bg.CreatedBy = Session["ID"].ToString();
            //bg.Status = 1;
            //bg.ScreenedBG = lblGroup1.Text;
            //bg.BloodCollection_Id = lblDonation1.Text;

            // string GroupingId = bg.Insert();
            string blooggroup = lblGroup1.Text;
            if (blooggroup == "")
                blooggroup = "NA";
            string GroupingId = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT bb_id_master('" + Session["centre"].ToString() + "','GRP')"));
            string query = "INSERT INTO bb_grouping(Grouping_Id,BloodCollection_Id,ScreenedBG,AntiA,AntiB,AntiAB,RH,CentreId,ACell,BCell,OCell,STATUS,CreatedBy,PatientID,IsPatient,TransactionID,ledgertransactionNo,IsApproved,ItemID,ApprovedBy) VALUES('" + GroupingId + "','" + lblDonation1.Text + "','" + blooggroup + "','" + AntiA + "','" + AntiB + "','" + AntiAB + "','" + RH + "','" + Session["CentreID"].ToString() + "','" + ACell + "','" + BCell + "','" + OCell + "',1,'" + Session["ID"].ToString() + "','" + lblPatientID1.Text + "',1,'" + lblTransactionID1.Text + "','" + lblLedgerTransaction1.Text + "',1,'" + lblItemID1.Text + "','" + Session["ID"].ToString() + "')";   // IsApproved : 1: pending
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);

            if (lbloldGroupID.Text != "")
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET STATUS='0',IsSame= 0,IsApproved =2 where Grouping_Id='" + lbloldGroupID.Text + "' ");
            }

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO bb_grouping_history(Grouping_Id,BloodCollection_Id,CentreId,IsActive,IsApproved) VALUES('" + GroupingId + "','" + lblDonation1.Text + "','" + Session["CentreID"].ToString() + "',1,3)");   // IsApproved : 1: pending

            string str = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select BloodAlloted from bb_BloodMatch_master where AntiA=" + AntiA + "  AND AntiB=" + AntiB + " AND AntiAB=" + AntiAB + " AND RH=" + RH + " "));
            string str1 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT ScreenedBG FROM bb_Grouping WHERE Grouping_Id='" + GroupingId + "' "));

            if (str == str1)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodTested='" + str + "',IsSame= 1,IsApproved =3 where Grouping_Id='" + GroupingId + "' ");
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodTested='" + str + "',IsSame= 1 ,IsApproved= 3  where Grouping_Id='" + GroupingId + "' ");
            }

            string Str2 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT BloodGroupAlloted from bb_BloodMatchReverse_Master where ACell=" + ACell + " AND BCell=" + BCell + " AND OCell=" + OCell + " "));   //
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodGroupAlloted='" + Str2 + "' WHERE Grouping_Id='" + GroupingId + "' ");

            string str3 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, " SELECT BGGroup from bb_BloodMatch_master where AntiA =" + AntiA + " AND AntiB=" + AntiB + " AND AntiAB=" + AntiAB + " AND  RH=" + RH + " "));  //
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BGTested='" + str3 + "' Where Grouping_Id='" + GroupingId + "' ");  //

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE patient_master SET BloodGroup='" + str3 + "' Where PatientID='" + lblPatientID1.Text.Trim() + "' ");  //


            Tranx.Commit();
            //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE	bb_visitors_history SET  IsGrouped =1 where BloodCollection_Id='" + lblDonation1.Text + "' ");



            //    string str = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select BloodAlloted from bb_BloodMatch_master where AntiA=" + AntiA + "  AND AntiB=" + AntiB + " AND AntiAB=" + AntiAB + " AND RH=" + RH + " "));
            //    string str1 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT ScreenedBG FROM bb_Grouping WHERE Grouping_Id='" + GroupingId + "' "));
            //    if (str == str1)
            //    {

            //        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodTested='" + str + "',IsSame= 1,IsApproved =3 where Grouping_Id='" + GroupingId + "' ");
            //        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history SET  IsGrouped =3 where BloodCollection_Id='" + lblDonation1.Text + "' ");
            //    }
            //    else
            //    {
            //        string visitorid = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT Visitor_ID FROM bb_visitors_history WHERE BloodCollection_Id ='" + lblDonation1.Text + "' "));
            //        string bloodid = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT id FROM bb_bloodgroup_master WHERE bloodgroup ='" + str + "' "));
            //        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodTested='" + str + "',IsSame= 0 ,IsApproved= 1  where Grouping_Id='" + GroupingId + "' ");
            //        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors SET BloodGroup_Id ='" + bloodid + "'  where Visitor_ID='" + visitorid + "' ");
            //    }

            //    string j = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT IsSame FROM bb_Grouping WHERE Grouping_Id ='" + GroupingId + "' "));
            //    string bloodcollection_id = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT bbgrpm.id FROM bb_Grouping grp INNER JOIN bb_bloodgroup_master bbgrpm ON bbgrpm.BloodGroup=grp.bloodtested WHERE grp.Grouping_Id ='" + GroupingId + "' "));
            //    string update = "UPDATE bb_visitors SET BloodGroup_Id='" + bloodcollection_id + "' where Visitor_ID='" + lblvisitors_id.Text + "' ";
            //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, update);

            //    string Str2 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT BloodGroupAlloted from bb_BloodMatchReverse_Master where ACell=" + ACell + " AND BCell=" + BCell + " AND OCell=" + OCell + " "));


            //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BloodGroupAlloted='" + Str2 + "' WHERE Grouping_Id='" + GroupingId + "' ");

            //    string str3 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, " SELECT BGGroup from bb_BloodMatch_master where AntiA =" + AntiA + " AND AntiB=" + AntiB + " AND AntiAB=" + AntiAB + " AND  RH=" + RH + " "));
            //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET BGTested='" + str3 + "' Where Grouping_Id='" + GroupingId + "' ");

            //    Tranx.Commit();
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

            StringBuilder sb2 = new StringBuilder();
            sb2.Append(" Select Grouping_Id,BloodCollection_Id,'' AS Sample,CASE WHEN (AntiA=1) THEN 'N' ELSE 'P' END  AS AntiA,  ");
            sb2.Append(" CASE WHEN (AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,");
            sb2.Append(" CASE WHEN (RH=1) THEN 'N' ELSE 'P' END AS RH,CASE WHEN (ACell=1) THEN 'N' ELSE 'P' END AS ACell,CASE WHEN (BCell=1) THEN 'N' ELSE 'P' END AS BCell,");
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
        lblPatientID1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblPatientID")).Text;
        lblTransactionID1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblTransactionID")).Text;
        lblLedgerTransaction1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblLedgertransaction")).Text;
        lblMotherID1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblMotherID")).Text;
        lblItemID1.Text = ((Label)grdGrouping.Rows[i].FindControl("lblItemID")).Text;

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
        DataTable dt = StockReports.GetDataTable(sb2.ToString());
        gridmatch.DataSource = dt;
        gridmatch.DataBind();
    }

    private void matchM()
    {
        //DataTable dt = StockReports.GetDataTable("Select bloodMasterID,AntiA,AntiA1,AntiB,AntiAB,AntiD,BloodAlloted,BgGroup from bb_bloodmatch_master  where ISActive=1");
        StringBuilder sb2 = new StringBuilder();
        sb2.Append(" Select bloodMasterID,CASE WHEN (AntiA=1) THEN 'N' ELSE 'P' END AS AntiA, ");
        sb2.Append(" CASE WHEN (AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,");
        sb2.Append(" CASE WHEN (RH=1) THEN 'N' ELSE 'P' END AS RH,BloodAlloted,BgGroup from bb_bloodmatch_master  where ISActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb2.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            for (int i = 1; i <= 8; i++)
            {
                DataRow dr = dt.NewRow();
                if (i == 1)
                    dr[5] = "A+";
                else if (i == 2)
                    dr[5] = "A-";
                else if (i == 3)
                    dr[5] = "B+";
                else if (i == 4)
                    dr[5] = "B-";
                else if(i==5)
                    dr[5] = "AB+";
                else if(i==6)
                    dr[5] = "AB-";
                else if(i==7)
                    dr[5] = "O+";
                else if(i==8)
                    dr[5] = "O-";
            }
            
        }
        gridmatch.DataSource = dt;
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

            sb.Append("SELECT IFNULL(bg.Grouping_Id,'')Grouping_Id,IF(SUBSTRING(pm.`Age`, LOCATE(' ', pm.`Age`))=' MONTH(S)',IF(LEFT(pm.`Age`,LOCATE(' ',pm.`Age`) - 1)<4,'True','False'),'False') 'Status',bg.BloodTested as `BloodGroup`,CONCAT(pm.Title,'',pm.PName) PName,pm.`PatientID`,pmh.TransactionID,IF(pmh.type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'') AS IPDNo,pmh.`MotherTID`,  ");
            sb.Append(" ltd.ItemName 'Blood Component',CONCAT(pm.Age,pm.Gender)AgeSex,lt.LedgerTransactionNo, ");
            sb.Append(" CONCAT((SELECT NAME FROM ipd_case_type_Master WHERE IPDCaseTypeID=(SELECT IPDCaseTypeID FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)),'/',(SELECT bed_no FROM room_master WHERE roomid=(SELECT roomid FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID LIMIT 1)))ward, ");
            sb.Append(" bcd.`BloodCollection_Id` 'CollectionID',bcd.`Visitor_Id`,bcd.`Visit_ID`,pmh.Type,im.`ItemID` FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  ");
            sb.Append(" INNER JOIN bb_collection_details bcd ON bcd.LedgerTransactionNo=lt.LedgerTransactionNo AND bcd.IsPatient=1 ");
            sb.Append(" LEFT JOIN bb_grouping bg ON bg.`BloodCollection_Id`=bcd.`BloodCollection_Id` AND bcd.`IsActive`=1 WHERE ");

            if (rbtType.Text == "IPD")
            {
                sb.Append(" pmh.`Type`='IPD' ");
            }

            if (rbtType.Text == "OPD")
            {
                sb.Append(" pmh.`Type`='OPD'  ");
            }

            if (rbtType.Text == "EMG")
            {
                sb.Append(" pmh.`Type`='EMG'  ");
            }

            if (rbtType.Text == "ALL")
            {
                sb.Append(" pmh.`Type` IN ('EMG','OPD','IPD')  ");
            }

            if (txtName.Text.Trim() != "")
            {
                sb.Append(" AND CONCAT(pm.`PFirstName`,' ',pm.`PLastName`) LIKE '" + txtName.Text.Trim() + "%' "); 
            }

            if (txtUHID.Text.Trim() != "")
            {
                 sb.Append(" AND pm.`PatientID`='" + txtUHID.Text.Trim() + "' "); 
            }

            if (txtIPDNo.Text.Trim() != "")
            {
               // sb.Append(" AND IF(pmh.type='IPD',REPLACE(pmh.Transaction_ID,'ISHHI',''),'')='" + txtIPDNo.Text.Trim() + "' ");

               sb.Append(" AND pmh.TransNo=" + txtIPDNo.Text.Trim() + " "); 
            }

            if (txtName.Text == string.Empty && txtIPDNo.Text == string.Empty && txtUHID.Text == string.Empty)
            {
                if (txtdonationfrom.Text != "")
                {
                    sb.Append(" AND DATE(lt.Date) >='" + Util.GetDateTime(txtdonationfrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtdonationTo.Text != "")
                {
                    sb.Append(" AND DATE(lt.Date) <='" + Util.GetDateTime(txtdonationTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }

            sb.Append(" AND IF(" + rdbtnGrouping.SelectedValue + "=1,bg.`BloodCollection_Id` IS NULL,bg.`BloodCollection_Id` IS NOT NULL and bg.Status=1) AND ltd.`CentreID`=" + Util.GetInt(ViewState["CenterID"]) + " AND ltd.`ConfigID`=7  GROUP BY ltd.`LedgerTransactionNo` ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdGrouping.DataSource = dt;
                grdGrouping.DataBind();
                pnlhide.Visible = true;
                lblMsg.Visible = false;
                lblMsg.Text = "";
            }
            else
            {
                grdGrouping.DataSource = null;
                grdGrouping.DataBind();
                pnlhide.Visible = false;
                lblMsg.Visible = true;
                lblMsg.Text = "Record not found";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrMsg.ClientID + "');", true);
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