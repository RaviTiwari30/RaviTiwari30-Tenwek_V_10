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

public partial class Design_MIS_MISIPDPackageAnalysis : System.Web.UI.Page
{
     
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            txtFromDateC.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDateC.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            
            string DateFrom = "", DateTo = "", SelectionType = "", DateType = "1";

            if (Request.QueryString["DateFrom"] != null && Request.QueryString["DateFrom"].ToString() != "")
                DateFrom = Request.QueryString["DateFrom"].ToString();

            if (Request.QueryString["DateTo"] != null && Request.QueryString["DateTo"].ToString() != "")
                DateTo = Request.QueryString["DateTo"].ToString();

            if (Request.QueryString["SelectionType"] != null && Request.QueryString["SelectionType"].ToString() != "")
                SelectionType = Request.QueryString["SelectionType"].ToString();

            if (Request.QueryString["DateType"] != null && Request.QueryString["DateType"].ToString() != "")
                DateType = Request.QueryString["DateType"].ToString();

            ViewState["DateFrom"] = Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd");
            ViewState["DateTo"] = Util.GetDateTime(DateTo).ToString("yyyy-MM-dd");
            ViewState["SelectionType"] = SelectionType;
            ViewState["DateType"] = DateType;
            lblClickedC.Text = SelectionType;            
        }
    }
   
    #region Analysis

    protected void btnCompare_Click(object sender, EventArgs e)
    {
        TimeSpan ts1 = Util.GetDateTime(ViewState["DateTo"].ToString()).Date - Util.GetDateTime(ViewState["DateFrom"].ToString()).Date;
        TimeSpan ts2 = Util.GetDateTime(txtToDateC.Text).Date - Util.GetDateTime(txtFromDateC.Text).Date;

        ViewState["DateFrom"] = ViewState["DateFrom"].ToString();
        ViewState["DateTo"] = ViewState["DateTo"].ToString();
        ViewState["DateFromC"] = Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd");
        ViewState["DateToC"] = Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd");        
        
        LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days+1), Util.GetString(ts2.Days+1), ViewState["DateType"].ToString(), "", "IPD", "", ViewState["SelectionType"].ToString());
        
        lblDocC.Visible = true;
        lblGroupC.Visible = true;
        lblItemwiseC.Visible = true;
        lblPanelC.Visible = true;

    }

    private void LoadComparisonData(string DateFrom, string DateTo, string CompDateFrom, string CompDateTo, string Days1, string Days2, string DateType, string TypeofTnx, string OPDIPD, string ConfigIds, string SelectionType)
    {
        if (OPDIPD == "IPD")
        {

            LoadComparisonDataIPD(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, DateType);                      
            
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["TypeofTnx"] = TypeofTnx;
            ViewState["SelectionType"] = SelectionType;
        }
    }

    private void LoadComparisonDataIPD(string DateFrom, string DateTo, string CompDateFrom, string CompDateTo, string Days1, string Days2, string DateType)
    {
        //For Doctor-wise
        DataTable dt = LoadIPDGrids(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, "DoctorID", DateType);        

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "DoctorID", rbtViewType.SelectedValue, Days1, Days2);

            grdDocC.DataSource = dt;
            grdDocC.DataBind();
        }
        else
        {
            grdDocC.DataSource = null;
            grdDocC.DataBind();
        }


        //For Itemwise-wise

        dt = LoadIPDGrids(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, "ItemID", DateType);        

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "ItemID", rbtViewType.SelectedValue, Days1, Days2);
            grdSpecC.DataSource = dt;
            grdSpecC.DataBind();

        }
        else
        {
            grdSpecC.DataSource = null;
            grdSpecC.DataBind();
        }

        //For SubCategorywise-wise

        dt = LoadIPDGrids(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, "SubCategoryID", DateType);        

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "SubCategoryID", rbtViewType.SelectedValue, Days1, Days2);
            grdSubCatC.DataSource = dt;
            grdSubCatC.DataBind();

        }
        else
        {
            grdSubCatC.DataSource = null;
            grdSubCatC.DataBind();
        }


        //For Panel-wise

        dt = LoadIPDGrids(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, "PanelID", DateType);        

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "PanelID", rbtViewType.SelectedValue, Days1, Days2);
            grdPanelC.DataSource = dt;
            grdPanelC.DataBind();

        }
        else
        {
            grdPanelC.DataSource = null;
            grdPanelC.DataBind();
        }
    }
   
    private void LoadDetailData(string DateFrom, string DateTo, string DateFromC, string DateToC, string FilterType, string DateType, string ID,string CompType)
    {
        string strQ = "";
        strQ += "SELECT  DATE,REPLACE(t.PatientID,'LSHHI','')MR_No,REPLACE(t.TransactionID,'ISHHI','')IP_No,";
        strQ += "(SELECT PName FROM Patient_master WHERE PatientID=t.PatientID)Pname,";
        strQ += "(SELECT NAME FROM employee_master WHERE employee_ID=t.UserID)GivenBy,";
        strQ += "(SELECT company_Name FROM f_panel_master WHERE PanelID=t.PanelID)Panel,";
        strQ += "(SELECT NAME FROM doctor_Master WHERE DoctorID=t.DoctorID)DocName,";
        strQ += "t.Department,(SELECT TypeName FROM f_itemmaster WHERE ITemID=t.ItemID)ItemName,";
        strQ += "Qty,Gross,Disc,Net ";
        strQ += "FROM (     ";
        strQ += "               SELECT IF(ltd.IsPackage=0,(ltd.Rate*ltd.Quantity),0)Gross,ucase(sc.DisplayName)DisplayName, ";
        strQ += "               ROUND(ltd.TotalDiscAmt,2)Disc,ltd.NetItemAmt Net,ltd.Quantity Qty, ";
        strQ += "               sc.Name Department, ";
        strQ += "               IF(IFNULL(ltd.DoctorID,'')='',adj.DoctorID,ltd.DoctorID)DoctorID,adj.PanelID PanelID,ltd.SubCategoryID,ltd.ItemID,  ";
        strQ += "               DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')DATE,ltd.UserID,adj.PatientID,adj.TransactionID ";
        strQ += "               FROM f_ipdadjustment adj INNER JOIN f_ledgertnxdetail ltd ON ";
        strQ += "               adj.TransactionID = ltd.TransactionID ";
        strQ += "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "               INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "               WHERE ltd.IsVerified=1 AND ltd.TransactionID LIKE 'ishhi%' ";


        if (DateType == "1")
        {
            if (CompType == "1")
                strQ += "       AND DATE(adj.BillDate)>='" + DateFrom + "' AND DATE(adj.BillDate)<='" + DateTo + "' ";
            else
                strQ += "       AND DATE(adj.BillDate)>='" + DateFromC + "' AND DATE(adj.BillDate)<='" + DateToC + "' ";

            strQ += "           AND IFNULL(adj.BillNo,'')<>'' ";
        }
        else
        {
            if (CompType == "1")
                strQ += "       AND ltd.EntryDate>='" + DateFrom + " 00:00:00' AND ltd.EntryDate<='" + DateTo + " 00:00:00' ";
            else
                strQ += "       AND ltd.EntryDate>='" + DateFromC + " 00:00:00' AND ltd.EntryDate<='" + DateToC + " 00:00:00' ";
        }
        strQ += "               AND cf.ConfigID=14 ";
        strQ += ")t  ";

        if (FilterType == "DoctorID")
            strQ += " INNER JOIN doctor_master dm ON dm.DoctorID = t.DoctorID  ";
        else if (FilterType == "ItemID")
            strQ += " INNER JOIN f_ItemMaster im ON im.ItemID = t.ItemID  ";
        else if (FilterType == "SubCategoryID")
            strQ += " INNER JOIN f_SubCategorymaster sm ON sm.SubCategoryID = t.SubCategoryID ";
        else if (FilterType == "PanelID")
            strQ += " INNER JOIN f_Panel_master pnl ON pnl.PanelID = t.PanelID ";

        if (FilterType == "DoctorID")
            strQ += " Where t.DoctorID ='" + ID + "'";
        else if (FilterType == "ItemID")
            strQ += " Where t.ItemID ='" + ID + "'";
        else if (FilterType == "SubCategoryID")
            strQ += " Where t.SubCategoryID ='" + ID + "'";
        else if (FilterType == "PanelID")
            strQ += " Where t.PanelID =" + ID + " ";

        strQ += " ORDER BY (REPLACE(t.TransactionID,'ISHHI','')+0),DATE ";

        DataTable dt = StockReports.GetDataTable(strQ);
        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();
            ((Label)grdDetails.FooterRow.FindControl("lblQtyT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
        }
    }
   
    private DataTable LoadIPDGrids(string DateFrom, string DateTo,string CompDateFrom, string CompDateTo, string Days1, string Days2, string FilterType, string DateType)
    {
        string strQ = "";
        strQ += "SELECT  ";

        if (FilterType == "DoctorID")
            strQ += "dm.Name, ";
        else if (FilterType == "ItemID")
            strQ += "im.TypeName Name, ";
        else if (FilterType == "SubCategoryID")
            strQ += "sm.Name, ";
        else if (FilterType == "PanelID")
            strQ += "pnl.Company_Name Name, ";

        strQ += "Round(SUM(Qty),2)Qty,Round(SUM(Gross),2)Gross,Round(SUM(Disc),2)Disc,Round(SUM(Net),2)Net,";
        if (DateType == "1")
            strQ += "if((DATE(t.BillDate) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType,  ";
        else
            strQ += "if((DATE(t.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType,  ";

        strQ += "t.DoctorID,t.PanelID,t.SubCategoryID,t.ItemID,'N' Growth FROM ( ";
        strQ += "           SELECT adj.BillDate,ltd.EntryDate Date, IF(ltd.IsPackage=0,(ltd.Rate*ltd.Quantity),0)Gross,ucase(sc.DisplayName)DisplayName, ";
        strQ += "           ROUND(ltd.TotalDiscAmt,2)Disc,ltd.NetItemAmt Net,ltd.Quantity Qty, ";
        strQ += "           IF(IFNULL(ltd.DoctorID,'')='',adj.DoctorID,ltd.DoctorID)DoctorID,  ";
        strQ += "           adj.PanelID PanelID,ltd.SubCategoryID,ltd.ItemID  ";
        strQ += "           FROM f_ipdadjustment adj INNER JOIN f_ledgertnxdetail ltd ON ";
        strQ += "           adj.TransactionID = ltd.TransactionID ";
        strQ += "           INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "           INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "           WHERE ltd.IsVerified=1 AND ltd.TransactionID LIKE 'ishhi%' ";

        if (DateType == "1")
        {
            strQ += "    AND IFNULL(adj.BillNo,'')<>'' ";
            strQ += "    AND ((Date(adj.BillDate) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
            strQ += "    OR (Date(adj.BillDate) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "')) ";
        }
        else
        {
            strQ += "    AND ((ltd.EntryDate Between '" + DateFrom + " 00:00:00' AND  '" + DateTo + " 00:00:00') ";
            strQ += "    OR (ltd.EntryDate Between '" + CompDateFrom + " 00:00:00' AND  '" + CompDateTo + " 00:00:00')) ";
        }
        strQ += "               AND cf.ConfigID=14  ";
        strQ += ")t  ";

        if (FilterType == "DoctorID")
            strQ += " INNER JOIN doctor_master dm ON dm.DoctorID = t.DoctorID GROUP BY dm.DoctorID,CompType";
        else if (FilterType == "ItemID")
            strQ += " INNER JOIN f_ItemMaster im ON im.ItemID = t.ItemID GROUP BY im.ItemID,CompType";
        else if (FilterType == "SubCategoryID")
            strQ += " INNER JOIN f_SubCategorymaster sm ON sm.SubCategoryID = t.SubCategoryID GROUP BY t.SubCategoryID,CompType";
        else if (FilterType == "PanelID")
            strQ += " INNER JOIN f_Panel_master pnl ON pnl.PanelID = t.PanelID GROUP BY t.PanelID,CompType";

        if (FilterType == "DoctorID")
            strQ += " order by dm.Name,CompType ";
        else if (FilterType == "ItemID")
            strQ += " order by im.TypeName,CompType ";
        else if (FilterType == "SubCategoryID")
            strQ += " order by sm.Name,CompType ";
        else if (FilterType == "PanelID")
            strQ += " order by pnl.Company_Name,CompType  ";


        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQ);
        return dt;
    }

    private DataTable MergeExtraRows(DataTable dtMain, string GroupingID, string ViewType, string Days1, string Days2)
    {
        dtMain.Columns.Add("QtyGrowth");
        dtMain.Columns.Add("GrossGrowth");
        dtMain.Columns.Add("DiscGrowth");
        dtMain.Columns.Add("NetGrowth");

        if (ViewType == "1")
            dtMain = GetActialCompFigure(dtMain, GroupingID);
        else
            dtMain = GetAvgPerDayData(dtMain, GroupingID, Days1, Days2);

        return dtMain;
    }

    private DataTable GetActialCompFigure(DataTable dtMain, string GroupingID)
    {

        for (int i = 0; i < dtMain.Rows.Count; i++)
        {
            DataRow[] drFound = dtMain.Select(GroupingID + "='" + dtMain.Rows[i][GroupingID].ToString() + "'");

            if (drFound.Length == 1)
            {
                //Adding a new row (copy of this dr having qty,gross,net,disc,collected with zero value

                DataRow drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Qty"] = "0";
                drNewRow["Gross"] = "0";
                drNewRow["Disc"] = "0";
                drNewRow["Net"] = "0";

                //Defining Growth for Color Coding
                dtMain.Rows[i]["Growth"] = "Y";
                drNewRow["Growth"] = "N";

                drNewRow["QtyGrowth"] = "N";
                drNewRow["GrossGrowth"] = "N";
                drNewRow["DiscGrowth"] = "N";
                drNewRow["NetGrowth"] = "N";

                dtMain.Rows[i]["QtyGrowth"] = "Y";
                dtMain.Rows[i]["GrossGrowth"] = "Y";
                dtMain.Rows[i]["DiscGrowth"] = "Y";
                dtMain.Rows[i]["NetGrowth"] = "Y";

                if (drNewRow["CompType"].ToString() == "1")
                    drNewRow["CompType"] = "2";
                else
                    drNewRow["CompType"] = "1";

                dtMain.Rows.InsertAt(drNewRow, i + 1);

                // Adding New Row to Calculate the Average of above Two Rows

                drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Name"] = "Difference Total :";
                drNewRow["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Qty"]), 2));
                drNewRow["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Gross"]), 2));
                drNewRow["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Disc"]), 2));
                drNewRow["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Net"]), 2));
                drNewRow["CompType"] = Util.GetString("3");

                if (dtMain.Rows[i]["CompType"].ToString() == "2")
                {
                    if (dtMain.Rows[i]["QtyGrowth"].ToString() == "N")
                        drNewRow["Qty"] = Util.GetString(Util.GetDecimal(drNewRow["Qty"]) * (-1));

                    if (dtMain.Rows[i]["GrossGrowth"].ToString() == "N")
                        drNewRow["Gross"] = Util.GetString(Util.GetDecimal(drNewRow["Gross"]) * (-1));

                    if (dtMain.Rows[i]["DiscGrowth"].ToString() == "N")
                        drNewRow["Disc"] = Util.GetString(Util.GetDecimal(drNewRow["Disc"]) * (-1));

                    if (dtMain.Rows[i]["NetGrowth"].ToString() == "N")
                        drNewRow["Net"] = Util.GetString(Util.GetDecimal(drNewRow["Net"]) * (-1));                    
                }

                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();
            }
            else if (drFound.Length == 2)
            {

                // Adding New Row to Calculate the Average of above Two Rows

                DataRow drNewRow = dtMain.NewRow();

                // Setting max Qty as Growth

                if (Util.GetString(drFound[0]["CompType"]) == "2")
                {
                    if (Util.GetDecimal(drFound[0]["Qty"]) > Util.GetDecimal(drFound[1]["Qty"]))
                    {
                        drFound[0]["Growth"] = "Y";
                        drFound[1]["Growth"] = "N";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        drNewRow["Growth"] = "Y";
                    }
                    else
                    {
                        drFound[0]["Growth"] = "N";
                        drFound[1]["Growth"] = "Y";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        drNewRow["Growth"] = "N";
                    }

                    drNewRow["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Qty"]) - Util.GetDecimal(drFound[1]["Qty"]), 2));
                    drNewRow["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Gross"]) - Util.GetDecimal(drFound[1]["Gross"]), 2));
                    drNewRow["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Disc"]) - Util.GetDecimal(drFound[1]["Disc"]), 2));
                    drNewRow["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Net"]) - Util.GetDecimal(drFound[1]["Net"]), 2));
                    drNewRow["CompType"] = Util.GetString("3");
                }
                else
                {
                    if (Util.GetDecimal(drFound[0]["Qty"]) > Util.GetDecimal(drFound[1]["Qty"]))
                    {
                        drFound[0]["Growth"] = "Y";
                        drFound[1]["Growth"] = "N";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        //IsGrowth = "N";
                    }
                    else
                    {
                        drFound[1]["Growth"] = "Y";
                        drFound[0]["Growth"] = "N";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        //IsGrowth = "Y";
                    }

                    drNewRow["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) - Util.GetDecimal(drFound[0]["Qty"]), 2));
                    drNewRow["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Gross"]) - Util.GetDecimal(drFound[0]["Gross"]), 2));
                    drNewRow["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Disc"]) - Util.GetDecimal(drFound[0]["Disc"]), 2));
                    drNewRow["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Net"]) - Util.GetDecimal(drFound[0]["Net"]), 2));
                    drNewRow["CompType"] = Util.GetString("3");
                }

                drNewRow["Name"] = "Difference Total :";

                if (Util.GetDecimal(drNewRow["Qty"]) >= 0)
                    drNewRow["QtyGrowth"] = "Y";
                else
                    drNewRow["QtyGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Gross"]) >= 0)
                    drNewRow["GrossGrowth"] = "Y";
                else
                    drNewRow["GrossGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Disc"]) >= 0)
                    drNewRow["DiscGrowth"] = "Y";
                else
                    drNewRow["DiscGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Net"]) >= 0)
                    drNewRow["NetGrowth"] = "Y";
                else
                    drNewRow["NetGrowth"] = "N";
               
                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();

            }
        }

        //Sorting Data on GroupID,CompType

        DataView dv = dtMain.DefaultView;
        dv.Sort = GroupingID + ",CompType";
        dtMain = dv.ToTable();

        //Adding Total for each Type

        DataRow dr = dtMain.NewRow();
        dr[0] = "Total of Ist Period";
        dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=1"))));
        dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Gross)", "CompType=1"))));
        dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Disc)", "CompType=1"))));
        dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Net)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=2"))));
        dr1["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Gross)", "CompType=2"))));
        dr1["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Disc)", "CompType=2"))));
        dr1["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Net)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "Total Difference";
        dr2["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Qty"]) - Util.GetDecimal(dr["Qty"])));
        dr2["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Gross"]) - Util.GetDecimal(dr["Gross"])));
        dr2["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Disc"]) - Util.GetDecimal(dr["Disc"])));
        dr2["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Net"]) - Util.GetDecimal(dr["Net"])));
        dr2["CompType"] = Util.GetString("3");

        if (Util.GetDecimal(dr2["Qty"]) >= 0)
            dr2["QtyGrowth"] = "Y";
        else
            dr2["QtyGrowth"] = "N";

        if (Util.GetDecimal(dr2["Gross"]) >= 0)
            dr2["GrossGrowth"] = "Y";
        else
            dr2["GrossGrowth"] = "N";

        if (Util.GetDecimal(dr2["Disc"]) >= 0)
            dr2["DiscGrowth"] = "Y";
        else
            dr2["DiscGrowth"] = "N";

        if (Util.GetDecimal(dr2["Net"]) >= 0)
            dr2["NetGrowth"] = "Y";
        else
            dr2["NetGrowth"] = "N";

        dtMain.Rows.InsertAt(dr2, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        return dtMain;
    }

    private DataTable GetAvgPerDayData(DataTable dtMain, string GroupingID, string Days1, string Days2)
    {
        for (int i = 0; i < dtMain.Rows.Count; i++)
        {
            DataRow[] drFound = dtMain.Select(GroupingID + "='" + dtMain.Rows[i][GroupingID].ToString() + "'");

            if (drFound.Length == 1)
            {
                //Adding a new row (copy of this dr having qty,gross,net,disc,collected with zero value

                DataRow drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Qty"] = "0";
                drNewRow["Gross"] = "0";
                drNewRow["Disc"] = "0";
                drNewRow["Net"] = "0";

                //Putting Avg per Day for each field

                dtMain.Rows[i]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Qty"]) / Util.GetDecimal(Days2), 2));
                dtMain.Rows[i]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Gross"]) / Util.GetDecimal(Days2), 2));
                dtMain.Rows[i]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Disc"]) / Util.GetDecimal(Days2), 2));
                dtMain.Rows[i]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Net"]) / Util.GetDecimal(Days2), 2));


                //Defining Growth for Color Coding
                dtMain.Rows[i]["Growth"] = "Y";
                drNewRow["Growth"] = "N";

                drNewRow["QtyGrowth"] = "N";
                drNewRow["GrossGrowth"] = "N";
                drNewRow["DiscGrowth"] = "N";
                drNewRow["NetGrowth"] = "N";

                dtMain.Rows[i]["QtyGrowth"] = "Y";
                dtMain.Rows[i]["GrossGrowth"] = "Y";
                dtMain.Rows[i]["DiscGrowth"] = "Y";
                dtMain.Rows[i]["NetGrowth"] = "Y";

                if (drNewRow["CompType"].ToString() == "1")
                    drNewRow["CompType"] = "2";
                else
                    drNewRow["CompType"] = "1";

                dtMain.Rows.InsertAt(drNewRow, i + 1);

                // Adding New Row to Calculate the Average of above Two Rows

                drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Name"] = "Total Growth/Decline in Percentage:";

                if (drNewRow["CompType"].ToString() == "1")
                {
                    drNewRow["Qty"] = "100";
                    drNewRow["Gross"] = "100";
                    drNewRow["Disc"] = "100";
                    drNewRow["Net"] = "100";
                }
                else
                {
                    drNewRow["Qty"] = "0";
                    drNewRow["Gross"] = "0";
                    drNewRow["Disc"] = "0";
                    drNewRow["Net"] = "0";
                }

                drNewRow["CompType"] = Util.GetString("3");

                if (dtMain.Rows[i]["CompType"].ToString() == "2")
                {
                    if (dtMain.Rows[i]["QtyGrowth"].ToString() == "N")
                        drNewRow["Qty"] = Util.GetString(Util.GetDecimal(drNewRow["Qty"]) * (-1));

                    if (dtMain.Rows[i]["GrossGrowth"].ToString() == "N")
                        drNewRow["Gross"] = Util.GetString(Util.GetDecimal(drNewRow["Gross"]) * (-1));

                    if (dtMain.Rows[i]["DiscGrowth"].ToString() == "N")
                        drNewRow["Disc"] = Util.GetString(Util.GetDecimal(drNewRow["Disc"]) * (-1));

                    if (dtMain.Rows[i]["NetGrowth"].ToString() == "N")
                        drNewRow["Net"] = Util.GetString(Util.GetDecimal(drNewRow["Net"]) * (-1));

                }

                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();
            }
            else if (drFound.Length == 2)
            {

                // Adding New Row to Calculate the Average of above Two Rows

                DataRow drNewRow = dtMain.NewRow();

                // Setting max Qty as Growth

                if (Util.GetString(drFound[0]["CompType"]) == "2")
                {
                    //Avg Per Day of 2nd Period
                    drFound[0]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Qty"]) / Util.GetDecimal(Days2)));
                    drFound[0]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Gross"]) / Util.GetDecimal(Days2)));
                    drFound[0]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Disc"]) / Util.GetDecimal(Days2)));
                    drFound[0]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Net"]) / Util.GetDecimal(Days2)));

                    //Avg Per Day of 1st Period
                    drFound[1]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) / Util.GetDecimal(Days1)));
                    drFound[1]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Gross"]) / Util.GetDecimal(Days1)));
                    drFound[1]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Disc"]) / Util.GetDecimal(Days1)));
                    drFound[1]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Net"]) / Util.GetDecimal(Days1)));

                    if (Util.GetDecimal(drFound[0]["Qty"]) > Util.GetDecimal(drFound[1]["Qty"]))
                    {
                        drFound[0]["Growth"] = "Y";
                        drFound[1]["Growth"] = "N";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        drNewRow["Growth"] = "Y";
                    }
                    else
                    {
                        drFound[0]["Growth"] = "N";
                        drFound[1]["Growth"] = "Y";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        drNewRow["Growth"] = "N";
                    }
                    if (Util.GetDecimal(drFound[1]["Qty"]) > 0)
                        drNewRow["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Qty"]) - Util.GetDecimal(drFound[1]["Qty"])) / Util.GetDecimal(drFound[1]["Qty"])) * 100, 2));
                    else
                        drNewRow["Qty"] = "100";
                    if (Util.GetDecimal(drFound[1]["Gross"]) > 0)
                        drNewRow["Gross"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Gross"]) - Util.GetDecimal(drFound[1]["Gross"])) / Util.GetDecimal(drFound[1]["Gross"])) * 100, 2));
                    else
                        drNewRow["Gross"] = "100";
                    if (Util.GetDecimal(drFound[1]["Disc"]) > 0)
                        drNewRow["Disc"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Disc"]) - Util.GetDecimal(drFound[1]["Disc"])) / Util.GetDecimal(drFound[1]["Disc"])) * 100, 2));
                    else
                        drNewRow["Disc"] = "100";
                    if (Util.GetDecimal(drFound[1]["Net"]) > 0)
                        drNewRow["Net"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Net"]) - Util.GetDecimal(drFound[1]["Net"])) / Util.GetDecimal(drFound[1]["Net"])) * 100, 2));
                    else
                        drNewRow["Net"] = "100";
                   
                    drNewRow["CompType"] = Util.GetString("3");
                }
                else
                {
                    //Avg Per Day of 2nd Period
                    drFound[0]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Qty"]) / Util.GetDecimal(Days1), 2));
                    drFound[0]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Gross"]) / Util.GetDecimal(Days1), 2));
                    drFound[0]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Disc"]) / Util.GetDecimal(Days1), 2));
                    drFound[0]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Net"]) / Util.GetDecimal(Days1), 2));

                    //Avg Per Day of 1st Period
                    drFound[1]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) / Util.GetDecimal(Days2), 2));
                    drFound[1]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Gross"]) / Util.GetDecimal(Days2), 2));
                    drFound[1]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Disc"]) / Util.GetDecimal(Days2), 2));
                    drFound[1]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Net"]) / Util.GetDecimal(Days2), 2));


                    if (Util.GetDecimal(drFound[0]["Qty"]) > Util.GetDecimal(drFound[1]["Qty"]))
                    {
                        drFound[0]["Growth"] = "Y";
                        drFound[1]["Growth"] = "N";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        //IsGrowth = "N";
                    }
                    else
                    {
                        drFound[1]["Growth"] = "Y";
                        drFound[0]["Growth"] = "N";
                        drNewRow.ItemArray = drFound[0].ItemArray;
                        //IsGrowth = "Y";
                    }

                    if (Util.GetDecimal(drFound[0]["Qty"]) > 0)
                        drNewRow["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["Qty"]) - Util.GetDecimal(drFound[0]["Qty"])) / Util.GetDecimal(drFound[0]["Qty"])) * 100, 2));
                    else
                        drNewRow["Qty"] = "100";

                    if (Util.GetDecimal(drFound[0]["Gross"]) > 0)
                        drNewRow["Gross"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["Gross"]) - Util.GetDecimal(drFound[0]["Gross"])) / Util.GetDecimal(drFound[0]["Gross"])) * 100, 2));
                    else
                        drNewRow["Gross"] = "100";

                    if (Util.GetDecimal(drFound[0]["Disc"]) > 0)
                        drNewRow["Disc"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["Disc"]) - Util.GetDecimal(drFound[0]["Disc"])) / Util.GetDecimal(drFound[0]["Disc"])) * 100, 2));
                    else
                        drNewRow["Disc"] = "100";

                    if (Util.GetDecimal(drFound[0]["Net"]) > 0)
                        drNewRow["Net"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["Net"]) - Util.GetDecimal(drFound[0]["Net"])) / Util.GetDecimal(drFound[0]["Net"])) * 100, 2));
                    else
                        drNewRow["Net"] = "100";                    

                    drNewRow["CompType"] = Util.GetString("3");
                }

                drNewRow["Name"] = "Total Growth/Decline in Percentage:";

                if (Util.GetDecimal(drNewRow["Qty"]) >= 0)
                    drNewRow["QtyGrowth"] = "Y";
                else
                    drNewRow["QtyGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Gross"]) >= 0)
                    drNewRow["GrossGrowth"] = "Y";
                else
                    drNewRow["GrossGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Disc"]) >= 0)
                    drNewRow["DiscGrowth"] = "Y";
                else
                    drNewRow["DiscGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Net"]) >= 0)
                    drNewRow["NetGrowth"] = "Y";
                else
                    drNewRow["NetGrowth"] = "N";

                dtMain.Rows.InsertAt(drNewRow, i + 2);

                dtMain.AcceptChanges();

            }
        }

        //Sorting Data on GroupID,CompType

        DataView dv = dtMain.DefaultView;
        dv.Sort = GroupingID + ",CompType";
        dtMain = dv.ToTable();

        //Adding Total for each Type

        DataRow dr = dtMain.NewRow();
        dr[0] = "Total of Ist Period";
        dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=1"))));
        dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Gross)", "CompType=1"))));
        dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Disc)", "CompType=1"))));
        dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Net)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=2"))));
        dr1["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Gross)", "CompType=2"))));
        dr1["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Disc)", "CompType=2"))));
        dr1["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Net)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "OverAll Growth/Decline in Percentage";

        if (Util.GetDecimal(dr["Qty"]) > 0)
            dr2["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Qty"]) - Util.GetDecimal(dr["Qty"])) / Util.GetDecimal(dr["Qty"])) * 100, 2));
        else
            dr2["Qty"] = "100";

        if (Util.GetDecimal(dr["Gross"]) > 0)
            dr2["Gross"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Gross"]) - Util.GetDecimal(dr["Gross"])) / Util.GetDecimal(dr["Gross"])) * 100, 2));
        else
            dr2["Gross"] = "100";

        if (Util.GetDecimal(dr["Disc"]) > 0)
            dr2["Disc"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Disc"]) - Util.GetDecimal(dr["Disc"])) / Util.GetDecimal(dr["Disc"])) * 100, 2));
        else
            dr2["Disc"] = "100";

        if (Util.GetDecimal(dr["Net"]) > 0)
            dr2["Net"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Net"]) - Util.GetDecimal(dr["Net"])) / Util.GetDecimal(dr["Net"])) * 100, 2));
        else
            dr2["Net"] = "100";

        dr2["CompType"] = Util.GetString("3");

        if (Util.GetDecimal(dr2["Qty"]) >= 0)
            dr2["QtyGrowth"] = "Y";
        else
            dr2["QtyGrowth"] = "N";

        if (Util.GetDecimal(dr2["Gross"]) >= 0)
            dr2["GrossGrowth"] = "Y";
        else
            dr2["GrossGrowth"] = "N";

        if (Util.GetDecimal(dr2["Disc"]) >= 0)
            dr2["DiscGrowth"] = "Y";
        else
            dr2["DiscGrowth"] = "N";

        if (Util.GetDecimal(dr2["Net"]) >= 0)
            dr2["NetGrowth"] = "Y";
        else
            dr2["NetGrowth"] = "N";        

        dtMain.Rows.InsertAt(dr2, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        return dtMain;
    }

    #endregion

    protected void grdDocC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompDoc")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompDoc")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompDoc")).Text == "3")
            {//System.Drawing.ColorTranslator.FromHtml("#404040")
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblDocQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblDocGrossGrowth")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblDocDiscGrowth")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblDocNetGrowth")).Text == "Y")
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");                

            }
        }
    }
    protected void grdSpecC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompSpec")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompSpec")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompSpec")).Text == "3")
            {
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblSpecQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSpecGrossGrowth")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSpecDiscGrowth")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSpecNetGrowth")).Text == "Y")
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");                
            }


        }
    }
    protected void grdSubCatC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompSubcat")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompSubcat")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompSubCat")).Text == "3")
            {
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblSubCatQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSubCatGrossGrowth")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSubCatDiscGrowth")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSubCatNetGrowth")).Text == "Y")
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");
                
            }


        }
    }
    protected void grdPanelC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompPanel")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompPanel")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompPanel")).Text == "3")
            {
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblPanelQtyGrowth")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblPanelGrossGrowth")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblPanelDiscGrowth")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblPanelNetGrowth")).Text == "Y")
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");               

            }

        }
    }

    protected void grdDocC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string DocID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();

            if (CompType != "3")
            {
                LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), "DoctorID",ViewState["DateType"].ToString(), DocID, CompType);
                mpSelect.Show();
            }
        }
    }
    protected void grdSpecC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string ItemID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            if (CompType != "3")
            {
                LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), "ItemID", ViewState["DateType"].ToString(), ItemID, CompType);
                mpSelect.Show();
            }
        }
    }
    protected void grdSubCatC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string SubCategoryID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            if (CompType != "3")
            {
                LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), "SubCategoryID", ViewState["DateType"].ToString(), SubCategoryID, CompType);
                mpSelect.Show();
            }
        }
    }
    protected void grdPanelC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string PanelID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            if (CompType != "3")
            {
                LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), "PanelID", ViewState["DateType"].ToString(), PanelID, CompType);
                mpSelect.Show();
            }
        }
    }
}
