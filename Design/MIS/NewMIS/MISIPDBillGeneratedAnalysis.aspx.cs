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

public partial class Design_MIS_MISIPDBillGeneratedAnalysis : System.Web.UI.Page
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
            
            LoadComparisonDataIPDBilling(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2);                      
            
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["TypeofTnx"] = TypeofTnx;
            ViewState["SelectionType"] = SelectionType;
        }
    }

    private void LoadComparisonDataIPDBilling(string DateFrom, string DateTo, string CompDateFrom, string CompDateTo, string Days1, string Days2)
    {
        string strQ = "";

        //For Doctor-wise

        strQ += "SELECT dm.Name,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill,SUM(MixedBill)MixedBill,dm.DoctorID,CompType FROM ( ";
        strQ += "    SELECT pmh.DoctorID,IF(adj.BillingType=1,1,0)OpenBill, ";
        strQ += "    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill,CompType  ";
        strQ += "    FROM f_ipdadjustment adj INNER JOIN ( ";
        strQ += "        SELECT TransactionID,if((DATE(BillDate) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM f_ledgertransaction ";
        strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' ";        
        strQ += "        AND (Date(BillDate) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "        OR (Date(BillDate) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += "        GROUP BY TransactionID ";
        strQ += "    )t ON adj.TransactionID =t.TransactionID INNER JOIN patient_medical_history pmh ON ";
        strQ += "    pmh.TransactionID = adj.TransactionID ";
        strQ += ")t INNER JOIN doctor_master dm ON t.DoctorID = dm.DoctorID ";
        strQ += "GROUP BY dm.DoctorID,CompType ORDER BY dm.Name,CompType ";

        DataTable dt = StockReports.GetDataTable(strQ);

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


        //For Specialization-wise

        strQ = "";

        strQ += "SELECT dm.Specialization Name,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill,SUM(MixedBill)MixedBill, ";
        strQ += "dm.Specialization ItemID,CompType FROM ( ";
        strQ += "    SELECT pmh.DoctorID,IF(adj.BillingType=1,1,0)OpenBill, ";
        strQ += "    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill,CompType ";
        strQ += "    FROM f_ipdadjustment adj INNER JOIN ( ";
        strQ += "        SELECT TransactionID,if((DATE(BillDate) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM f_ledgertransaction  ";
        strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' ";
        strQ += "        AND (Date(BillDate) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "        OR (Date(BillDate) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += "        GROUP BY TransactionID ";
        strQ += "    )t ON adj.TransactionID =t.TransactionID INNER JOIN patient_medical_history pmh ON  ";
        strQ += "    pmh.TransactionID = adj.TransactionID ";
        strQ += ")t INNER JOIN doctor_master dm ON t.DoctorID = dm.DoctorID ";
        strQ += "GROUP BY dm.Specialization,CompType ORDER BY dm.Specialization,CompType ";

        dt = StockReports.GetDataTable(strQ);

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

        //For RoomType-wise

        strQ = "";

        strQ += "SELECT BillDate NAME ,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill,SUM(MixedBill)MixedBill,CompType FROM ( ";
        strQ += "    SELECT IF(adj.BillingType=1,1,0)OpenBill, ";
        strQ += "    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill, ";
        strQ += "    t.BillDate,CompType FROM f_ipdadjustment adj INNER JOIN ( ";
        strQ += "        SELECT TransactionID,DATE_FORMAT(billdate,'%d-%b-%y')BillDate, ";
        strQ += "        if((DATE(BillDate) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM f_ledgertransaction ";
        strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' ";
        strQ += "        AND (Date(BillDate) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "        OR (Date(BillDate) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += "        GROUP BY TransactionID ";
        strQ += "    )t ON adj.TransactionID = t.TransactionID ";
        strQ += ")t GROUP BY BillDate,CompType ORDER BY BillDate,CompType ";
        
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "NAME", rbtViewType.SelectedValue, Days1, Days2);
            grdBillDateC.DataSource = dt;
            grdBillDateC.DataBind();

        }
        else
        {
            grdBillDateC.DataSource = null;
            grdBillDateC.DataBind();
        }


        //For Panel-wise

        strQ = "";

        strQ += "SELECT pnl.Company_Name NAME ,SUM(OpenBill)OpenBill,SUM(PkgBill)PkgBill, ";
        strQ += "SUM(MixedBill)MixedBill,pnl.PanelID,CompType FROM ( ";
        strQ += "    SELECT pmh.PanelID,IF(adj.BillingType=1,1,0)OpenBill, ";
        strQ += "    IF(adj.BillingType=2,1,0)PkgBill,IF(adj.BillingType=3,1,0)MixedBill,CompType ";
        strQ += "    FROM f_ipdadjustment adj INNER JOIN ( ";
        strQ += "        SELECT TransactionID,if((DATE(BillDate) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType FROM f_ledgertransaction ";
        strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' ";
        strQ += "    AND (Date(BillDate) Between '" + DateFrom + "' AND  '" + DateTo + "') ";
        strQ += "    OR (Date(BillDate) Between '" + CompDateFrom + "' AND  '" + CompDateTo + "') ";
        strQ += "        GROUP BY TransactionID ";
        strQ += "    )t ON adj.TransactionID =t.TransactionID INNER JOIN patient_medical_history pmh ON ";
        strQ += "    pmh.TransactionID = adj.TransactionID ";
        strQ += ")t INNER JOIN f_panel_master pnl ON t.PanelID = pnl.PanelID ";
        strQ += "GROUP BY pnl.PanelID,CompType ORDER BY pnl.Company_Name,CompType";
                
        dt = StockReports.GetDataTable(strQ);

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

    private void LoadDocDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string DocID, string CompType)
    {
        TypeofTnx = "DoctorID";
        LoadDetailGrid(DateFrom, DateTo, DateFromC, DateToC, TypeofTnx, DocID, CompType);

    }

    private void LoadItemDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string Specialization, string CompType)
    {
        TypeofTnx = "Specialization";
        LoadDetailGrid(DateFrom, DateTo, DateFromC, DateToC, TypeofTnx, Specialization,CompType);

    }

    private void LoadSubCatDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string BillDate, string CompType)
    {
        TypeofTnx = "BillDate";
        LoadDetailGrid(DateFrom, DateTo, DateFromC, DateToC, TypeofTnx, BillDate, CompType);

    }

    private void LoadPanelDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string PanelID, string CompType)
    {
        TypeofTnx = "PanelID";
        LoadDetailGrid(DateFrom, DateTo, DateFromC, DateToC, TypeofTnx, PanelID, CompType);
    }

    private DataTable MergeExtraRows(DataTable dtMain, string GroupingID,string ViewType,string Days1,string Days2)
    {
        dtMain.Columns.Add("QtyGrowthOpenBill");
        dtMain.Columns.Add("QtyGrowthPkgBill");
        dtMain.Columns.Add("QtyGrowthMixedBill");

        if(ViewType =="1")
            dtMain = GetActialCompFigure(dtMain,GroupingID);
        else
            dtMain = GetAvgPerDayData(dtMain,GroupingID, Days1, Days2);

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

                drNewRow["OpenBill"] = "0";
                drNewRow["PkgBill"] = "0";
                drNewRow["MixedBill"] = "0";                

                //Defining Growth for Color Coding

                drNewRow["QtyGrowthOpenBill"] = "N";
                dtMain.Rows[i]["QtyGrowthOpenBill"] = "Y";

                drNewRow["QtyGrowthPkgBill"] = "N";
                dtMain.Rows[i]["QtyGrowthPkgBill"] = "Y";

                drNewRow["QtyGrowthMixedBill"] = "N";
                dtMain.Rows[i]["QtyGrowthMixedBill"] = "Y"; 

                if (drNewRow["CompType"].ToString() == "1")
                    drNewRow["CompType"] = "2";
                else
                    drNewRow["CompType"] = "1";

                dtMain.Rows.InsertAt(drNewRow, i + 1);

                // Adding New Row to Calculate the Average of above Two Rows

                drNewRow = dtMain.NewRow();
                drNewRow.ItemArray = dtMain.Rows[i].ItemArray;

                drNewRow["Name"] = "Difference Total :";
                drNewRow["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["OpenBill"]), 2));
                drNewRow["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["PkgBill"]), 2));
                drNewRow["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["MixedBill"]), 2));
                drNewRow["CompType"] = Util.GetString("3");

                if (dtMain.Rows[i]["CompType"].ToString() == "2")
                {
                    if (dtMain.Rows[i]["QtyGrowthOpenBill"].ToString() == "N")
                        drNewRow["OpenBill"] = Util.GetString(Util.GetDecimal(drNewRow["OpenBill"]) * (-1));

                    if (dtMain.Rows[i]["QtyGrowthPkgBill"].ToString() == "N")
                        drNewRow["PkgBill"] = Util.GetString(Util.GetDecimal(drNewRow["PkgBill"]) * (-1));

                    if (dtMain.Rows[i]["QtyGrowthMixedBill"].ToString() == "N")
                        drNewRow["MixedBill"] = Util.GetString(Util.GetDecimal(drNewRow["MixedBill"]) * (-1));
                    
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
                    drNewRow.ItemArray = drFound[0].ItemArray;

                    drNewRow["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["OpenBill"]) - Util.GetDecimal(drFound[1]["OpenBill"]), 2));
                    drNewRow["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["PkgBill"]) - Util.GetDecimal(drFound[1]["PkgBill"]), 2));
                    drNewRow["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["MixedBill"]) - Util.GetDecimal(drFound[1]["MixedBill"]), 2));
                    drNewRow["CompType"] = Util.GetString("3");
                }
                else
                {
                    drNewRow.ItemArray = drFound[0].ItemArray;

                    drNewRow["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["OpenBill"]) - Util.GetDecimal(drFound[0]["OpenBill"]), 2));
                    drNewRow["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["PkgBill"]) - Util.GetDecimal(drFound[0]["PkgBill"]), 2));
                    drNewRow["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["MixedBill"]) - Util.GetDecimal(drFound[0]["MixedBill"]), 2));
                    drNewRow["CompType"] = Util.GetString("3");
                }

                drNewRow["Name"] = "Difference Total :";

                if (Util.GetDecimal(drNewRow["OpenBill"]) >= 0)
                    drNewRow["QtyGrowthOpenBill"] = "Y";
                else
                    drNewRow["QtyGrowthOpenBill"] = "N";

                if (Util.GetDecimal(drNewRow["PkgBill"]) >= 0)
                    drNewRow["QtyGrowthPkgBill"] = "Y";
                else
                    drNewRow["QtyGrowthPkgBill"] = "N";

                if (Util.GetDecimal(drNewRow["MixedBill"]) >= 0)
                    drNewRow["QtyGrowthMixedBill"] = "Y";
                else
                    drNewRow["QtyGrowthMixedBill"] = "N";   

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
        dr["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(OpenBill)", "CompType=1"))));
        dr["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(PkgBill)", "CompType=1"))));
        dr["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(MixedBill)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(OpenBill)", "CompType=2"))));
        dr1["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(PkgBill)", "CompType=2"))));
        dr1["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(MixedBill)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "Total Difference";
        dr2["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["OpenBill"]) - Util.GetDecimal(dr["OpenBill"])));
        dr2["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["PkgBill"]) - Util.GetDecimal(dr["PkgBill"])));
        dr2["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["MixedBill"]) - Util.GetDecimal(dr["MixedBill"])));
        dr2["CompType"] = Util.GetString("3");

        if (Util.GetDecimal(dr2["OpenBill"]) >= 0)
            dr2["QtyGrowthOpenBill"] = "Y";
        else
            dr2["QtyGrowthOpenBill"] = "N";

        if (Util.GetDecimal(dr2["PkgBill"]) >= 0)
            dr2["QtyGrowthPkgBill"] = "Y";
        else
            dr2["QtyGrowthPkgBill"] = "N";

        if (Util.GetDecimal(dr2["MixedBill"]) >= 0)
            dr2["QtyGrowthMixedBill"] = "Y";
        else
            dr2["QtyGrowthMixedBill"] = "N";

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

                drNewRow["OpenBill"] = "0";
                drNewRow["PkgBill"] = "0";
                drNewRow["MixedBill"] = "0";    

                //Putting Avg per Day for each field

                dtMain.Rows[i]["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["OpenBill"]) / Util.GetDecimal(Days2), 2));
                dtMain.Rows[i]["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["PkgBill"]) / Util.GetDecimal(Days2), 2));
                dtMain.Rows[i]["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["MixedBill"]) / Util.GetDecimal(Days2), 2));
                
                //Defining Growth for Color Coding

                drNewRow["QtyGrowthOpenBill"] = "N";
                dtMain.Rows[i]["QtyGrowthOpenBill"] = "Y";
                drNewRow["QtyGrowthPkgBill"] = "N";
                dtMain.Rows[i]["QtyGrowthPkgBill"] = "Y";
                drNewRow["QtyGrowthMixedBill"] = "N";
                dtMain.Rows[i]["QtyGrowthMixedBill"] = "Y";
                
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
                    drNewRow["OpenBill"] = "100";
                    drNewRow["PkgBill"] = "100";
                    drNewRow["MixedBill"] = "100";    
                }
                else
                {
                    drNewRow["OpenBill"] = "0";
                    drNewRow["PkgBill"] = "0";
                    drNewRow["MixedBill"] = "0";              
                }

                drNewRow["CompType"] = Util.GetString("3");

                if (dtMain.Rows[i]["CompType"].ToString() == "2")
                {
                    if (dtMain.Rows[i]["QtyGrowthOpenBill"].ToString() == "N")
                        drNewRow["OpenBill"] = Util.GetString(Util.GetDecimal(drNewRow["OpenBill"]) * (-1));
                    if (dtMain.Rows[i]["QtyGrowthPkgBill"].ToString() == "N")
                        drNewRow["PkgBill"] = Util.GetString(Util.GetDecimal(drNewRow["PkgBill"]) * (-1));
                    if (dtMain.Rows[i]["QtyGrowthMixedBill"].ToString() == "N")
                        drNewRow["MixedBill"] = Util.GetString(Util.GetDecimal(drNewRow["MixedBill"]) * (-1));
                    
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
                    drFound[0]["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["OpenBill"]) / Util.GetDecimal(Days2)));
                    drFound[0]["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["PkgBill"]) / Util.GetDecimal(Days2)));
                    drFound[0]["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["MixedBill"]) / Util.GetDecimal(Days2)));
                    
                    //Avg Per Day of 1st Period
                    drFound[0]["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["OpenBill"]) / Util.GetDecimal(Days2)));
                    drFound[0]["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["PkgBill"]) / Util.GetDecimal(Days2)));
                    drFound[0]["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["MixedBill"]) / Util.GetDecimal(Days2)));
                    drNewRow.ItemArray = drFound[0].ItemArray;

                    if (Util.GetDecimal(drFound[1]["OpenBill"]) > 0)
                        drNewRow["OpenBill"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["OpenBill"]) - Util.GetDecimal(drFound[1]["OpenBill"])) / Util.GetDecimal(drFound[1]["OpenBill"])) * 100, 2));
                    else
                        drNewRow["OpenBill"] = "100";

                    if (Util.GetDecimal(drFound[1]["PkgBill"]) > 0)
                        drNewRow["PkgBill"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["PkgBill"]) - Util.GetDecimal(drFound[1]["PkgBill"])) / Util.GetDecimal(drFound[1]["PkgBill"])) * 100, 2));
                    else
                        drNewRow["PkgBill"] = "100";

                    if (Util.GetDecimal(drFound[1]["MixedBill"]) > 0)
                        drNewRow["MixedBill"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["MixedBill"]) - Util.GetDecimal(drFound[1]["MixedBill"])) / Util.GetDecimal(drFound[1]["MixedBill"])) * 100, 2));
                    else
                        drNewRow["MixedBill"] = "100";                    


                    drNewRow["CompType"] = Util.GetString("3");
                }
                else
                {
                    //Avg Per Day of 2nd Period
                    drFound[0]["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["OpenBill"]) / Util.GetDecimal(Days1), 2));
                    drFound[0]["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["PkgBill"]) / Util.GetDecimal(Days1), 2));
                    drFound[0]["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["MixedBill"]) / Util.GetDecimal(Days1), 2));
                    
                    //Avg Per Day of 1st Period
                    drFound[1]["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["OpenBill"]) / Util.GetDecimal(Days2), 2));
                    drFound[1]["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["PkgBill"]) / Util.GetDecimal(Days2), 2));
                    drFound[1]["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["MixedBill"]) / Util.GetDecimal(Days2), 2));
                    drNewRow.ItemArray = drFound[0].ItemArray;

                    if (Util.GetDecimal(drFound[0]["OpenBill"]) > 0)
                        drNewRow["OpenBill"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["OpenBill"]) - Util.GetDecimal(drFound[0]["OpenBill"])) / Util.GetDecimal(drFound[0]["OpenBill"])) * 100, 2));
                    else
                        drNewRow["OpenBill"] = "100";

                    if (Util.GetDecimal(drFound[0]["PkgBill"]) > 0)
                        drNewRow["PkgBill"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["PkgBill"]) - Util.GetDecimal(drFound[0]["PkgBill"])) / Util.GetDecimal(drFound[0]["PkgBill"])) * 100, 2));
                    else
                        drNewRow["PkgBill"] = "100";

                    if (Util.GetDecimal(drFound[0]["MixedBill"]) > 0)
                        drNewRow["MixedBill"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["MixedBill"]) - Util.GetDecimal(drFound[0]["MixedBill"])) / Util.GetDecimal(drFound[0]["MixedBill"])) * 100, 2));
                    else
                        drNewRow["MixedBill"] = "100";

                    drNewRow["CompType"] = Util.GetString("3");
                }

                drNewRow["Name"] = "Total Growth/Decline in Percentage:";

                if (Util.GetDecimal(drNewRow["OpenBill"]) >= 0)
                    drNewRow["QtyGrowthOpenBill"] = "Y";
                else
                    drNewRow["QtyGrowthOpenBill"] = "N";

                if (Util.GetDecimal(drNewRow["PkgBill"]) >= 0)
                    drNewRow["QtyGrowthPkgBill"] = "Y";
                else
                    drNewRow["QtyGrowthPkgBill"] = "N";

                if (Util.GetDecimal(drNewRow["MixedBill"]) >= 0)
                    drNewRow["QtyGrowthMixedBill"] = "Y";
                else
                    drNewRow["QtyGrowthMixedBill"] = "N";   

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
        dr["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(OpenBill)", "CompType=1"))));
        dr["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(PkgBill)", "CompType=1"))));
        dr["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(MixedBill)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["OpenBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(OpenBill)", "CompType=2"))));
        dr1["PkgBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(PkgBill)", "CompType=2"))));
        dr1["MixedBill"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(MixedBill)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "OverAll Growth/Decline in Percentage";

        if (Util.GetDecimal(dr["OpenBill"]) > 0)
            dr2["OpenBill"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["OpenBill"]) - Util.GetDecimal(dr["OpenBill"])) / Util.GetDecimal(dr["OpenBill"])) * 100, 2));
        else
            dr2["OpenBill"] = "100";

        if (Util.GetDecimal(dr["PkgBill"]) > 0)
            dr2["PkgBill"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["PkgBill"]) - Util.GetDecimal(dr["PkgBill"])) / Util.GetDecimal(dr["PkgBill"])) * 100, 2));
        else
            dr2["PkgBill"] = "100";


        if (Util.GetDecimal(dr["MixedBill"]) > 0)
            dr2["MixedBill"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["MixedBill"]) - Util.GetDecimal(dr["MixedBill"])) / Util.GetDecimal(dr["MixedBill"])) * 100, 2));
        else
            dr2["MixedBill"] = "100";
                
        dr2["CompType"] = Util.GetString("3");

        if (Util.GetDecimal(dr2["OpenBill"]) >= 0)
            dr2["QtyGrowthOpenBill"] = "Y";
        else
            dr2["QtyGrowthOpenBill"] = "N";

        if (Util.GetDecimal(dr2["PkgBill"]) >= 0)
            dr2["QtyGrowthPkgBill"] = "Y";
        else
            dr2["QtyGrowthPkgBill"] = "N";

        if (Util.GetDecimal(dr2["MixedBill"]) >= 0)
            dr2["QtyGrowthMixedBill"] = "Y";
        else
            dr2["QtyGrowthMixedBill"] = "N";

        dtMain.Rows.InsertAt(dr2, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        return dtMain;
    }

    private void LoadDetailGrid(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string ID,string CompType)
    {
        string strQ = "";

        strQ += " SELECT BillingType,BillDate,BillNo,Replace(PatientID,'LSHHI','')MR_No,REPLACE(T4.TransactionID,'ISHHI','')IP_No,UPPER(PName)PName,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%y')DateOfAdmit,DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%y')DateOfDischarge, ";
        strQ += " (SELECT CONCAT(Bed_No,'-',UPPER(NAME))Room FROM room_master WHERE Room_ID= (SELECT Room_ID FROM patient_ipd_profile  ";
        strQ += " WHERE PatientIPDProfile_ID =(SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=T4.TransactionID)))Room,UPPER(DoctorName)DoctorName,UCASE(Specialization)Specialization,  ";
        strQ += " ROUND(CAST(GrossAmt AS DECIMAL(15,2)),2)GrossBillAmt,ROUND(CAST(TotalDiscount AS DECIMAL(15,2)),2)TotalDiscount,ROUND(CAST(NetAmount AS DECIMAL(15,2)),2)AS NetBillAmount,  ";
        strQ += " CAST(if(UPPER(PName)not like '%Cancel%',(SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =T4.TransactionID AND IsCancel = 0 AND AmountPaid >0 GROUP BY T4.TransactionID),0) AS DECIMAL(15,2))TotalDeposit, ";
        strQ += " CAST(if(UPPER(PName)not like '%Cancel%',(SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =T4.TransactionID AND IsCancel = 0 AND AmountPaid <0 GROUP BY T4.TransactionID),0) AS DECIMAL(15,2))TotalRefund, ";
        strQ += " ROUND(CAST(ReceiveAmt AS DECIMAL(15,2)),2)ReceiveAmt,ROUND(CAST(AdjustmentAmt AS DECIMAL(15,2)),2)AdjustmentAmt,ROUND(CAST(OutStanding AS DECIMAL(15,2)),2) AS OutStanding,ROUND(CAST(TDS AS DECIMAL(15,2)),2)TDS, ";
        strQ += " ROUND(CAST(Deduction_Acceptable AS DECIMAL(15,2)),2)DeductionAcceptable,ROUND(CAST(Deduction_NonAcceptable AS DECIMAL(15,2)),2)DeductionNonAcceptable,ROUND(CAST(WriteOff AS DECIMAL(15,2)),2)WriteOff,ROUND(CAST(CreditAmt AS DECIMAL(15,2)),2)CreditAmt,ROUND(CAST(DebitAmt AS DECIMAL(15,2)),2)DebitAmt, ";
        strQ += " CAST(ServiceTaxAmt AS DECIMAL(15,2))ServiceTaxAmt,CAST(ServiceTaxSurChgAmt AS DECIMAL(15,2))ServiceTaxSurChgAmt, ";
        strQ += " UPPER(DiscountOnBillReason)DiscountOnBillReason,UPPER(ApprovalBy)ApprovalBy,UPPER(Panel)Panel,CAST(PanelApprovedAmt AS DECIMAL(15,2))PanelApprovedAmt,  ";
        strQ += " UPPER(PolicyNo)PolicyNo,UPPER(CardNo)CardNo,UPPER(ClaimNo)ClaimNo,UPPER(PanelAppRemarks)PanelAppRemarks,PanelApprovalDate,UPPER(UserID) BillGeneratedBy,IF(IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus FROM ( ";
        strQ += "      SELECT BillingType,DATE_FORMAT(BillDate,'%d-%b-%y')BillDate,BillNo,PatientID,TransactionID,PName,ROUND(TotalBilledAmt) GrossAmt, ";
        strQ += "      ROUND((ItemWiseDiscount+DiscountOnBill))TotalDiscount,ROUND((TotalBilledAmt-(ItemWiseDiscount+DiscountOnBill))) ";
        strQ += "      AS NetAmount,ROUND(AdjustmentAmt)AdjustmentAmt,ROUND(ReceiveAmt)ReceiveAmt, ";
        strQ += "      ROUND(((TotalBilledAmt)-(ItemWiseDiscount+DiscountOnBill+AdjustmentAmt+ReceiveAmt+TDS+Deduction_Acceptable+Deduction_NonAcceptable+WriteOff)-CreditAmt+DebitAmt + ServiceTaxAmt+ServiceTaxSurChgAmt)) AS OutStanding, ";
        strQ += "      UserID,DoctorName,Specialization, Panel,ROUND(TDS)TDS,ROUND(Deduction_Acceptable)Deduction_Acceptable,ROUND(Deduction_NonAcceptable)Deduction_NonAcceptable,ROUND(WriteOff)WriteOff,ROUND(CreditAmt)CreditAmt,ROUND(DebitAmt)DebitAmt,ROUND(ServiceTaxAmt,2)ServiceTaxAmt,ROUND(ServiceTaxSurChgAmt,2)ServiceTaxSurChgAmt,  ";
        strQ += "      PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed  FROM ( ";
        strQ += "           SELECT BillingType,BillDate,BillNo,PatientID,TransactionID,PName, ";
        strQ += "           IF(TotalBilledAmt IS NULL,0,TotalBilledAmt)TotalBilledAmt, ";
        strQ += "           IF(ItemWiseDiscount IS NULL,0,ItemWiseDiscount)ItemWiseDiscount, ";
        strQ += "           IF(DiscountOnBill IS NULL,0,DiscountOnBill)DiscountOnBill, ";
        strQ += "           IF(AdjustmentAmt IS NULL,0,AdjustmentAmt)AdjustmentAmt,IF(ReceiveAmt IS NULL,0,ReceiveAmt)ReceiveAmt , ";
        strQ += "           UserID,DoctorName,Specialization,IF(TDS IS NULL,0,TDS)TDS,Deduction_Acceptable,Deduction_NonAcceptable,WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,ServiceTaxSurChgAmt,Panel, ";
        strQ += "           PolicyNo,CardNo,ClaimNo,PanelApprovedAmt,PanelAppRemarks,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed FROM ( ";
        strQ += "               SELECT T1.BillingType,T1.BillNo,T1.BillDate,T1.PatientID,T1.TransactionID,T1.TotalBilledAmt,T1.DiscountOnBill,T1.TDS,T1.Deduction_Acceptable,T1.Deduction_NonAcceptable,T1.WriteOff,T1.CreditAmt,T1.DebitAmt,T1.AdjustmentAmt,  ";
        strQ += "               T1.ReceiveAmt,T1.ItemWiseDiscount,T1.PName,Em.Name UserID,ServiceTaxAmt,ServiceTaxSurChgAmt,dm.Name DoctorName,dm.Specialization, T1.PolicyNo, ";
        strQ += "               T1.CardNo,T1.ClaimNo,T1.PanelApprovedAmt,T1.PanelAppRemarks,if(PanelApprovalDate='0001-01-01','',DATE_FORMAT(T1.PanelApprovalDate,'%d-%b-%y'))PanelApprovalDate,T1.DiscountOnBillReason,T1.ApprovalBy,  ";
        strQ += "               PM.Company_Name Panel,IsBilledClosed FROM ( ";
        strQ += "                   SELECT BillingType,BillNo,BillDate,PatientID,Temp1.TransactionID, ";
        strQ += "                   (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ltd  ";
        strQ += "                   INNER JOIN f_Itemmaster im ON im.ItemID = Ltd.ItemID  ";
        strQ += "                   WHERE ltd.TransactionID = Temp1.TransactionID AND ltd.IsVerified = 1 AND  ";
        strQ += "                   ltd.IsPackage = 0     ";
        strQ += "                   GROUP BY TransactionID)TotalBilledAmt, ";
        strQ += "                   DiscountOnBill,AdjustmentAmt,(SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =Temp1.TransactionID ";
        strQ += "                   AND IsCancel = 0 GROUP BY TransactionID)ReceiveAmt, ";
        strQ += "                   (SELECT SUM(((Rate*Quantity)*DiscountPercentage)/100) FROM  ";
        strQ += "                   f_ledgertnxdetail WHERE TransactionID = Temp1.TransactionID  ";
        strQ += "                   AND IsVerified = 1 AND IsPackage = 0 ";
        strQ += "                   GROUP BY TransactionID)ItemWiseDiscount, UserID,TDS,Deduction_Acceptable,Deduction_NonAcceptable,WriteOff,CreditAmt,DebitAmt,ServiceTaxAmt,ServiceTaxSurChgAmt,PName,ClaimNo,PanelAppRemarks, ";
        strQ += "                   PanelApprovedAmt,PanelApprovalDate,DiscountOnBillReason,ApprovalBy,IsBilledClosed, ";
        strQ += "                   PolicyNo,CardNo,DoctorID,PanelID  FROM  ( ";
        strQ += "                       SELECT (case when adj.BillingType=1 then 'OpenBill' when adj.BillingType=2 then 'PkgBill' else 'MixedBill' end)BillingType,";
        strQ += "                       LT.BillNo,LT.BillDate,Adj.PatientID,Adj.TransactionID, ";
        strQ += "                       Adj.TotalBilledAmt,Adj.DiscountOnBill,Adj.AdjustmentAmt,Adj.UserID,IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.Deduction_Acceptable,0)Deduction_Acceptable, ";
        strQ += "                       IFNULL(pmh.Deduction_NonAcceptable,0)Deduction_NonAcceptable,IFNULL(pmh.WriteOff,0)WriteOff, ";
        strQ += "                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ";
        strQ += "                       AND CRDR='CR01' AND cancel=0  GROUP BY TransactionID),0)CreditAmt, ";
        strQ += "                       IFNULL((SELECT SUM(amount) FROM f_drcrnote WHERE TransactionID=lt.TransactionID  ";
        strQ += "                       AND CRDR='DR01' AND cancel=0 GROUP BY TransactionID),0)DebitAmt, ";
        strQ += "                       Adj.ServiceTaxAmt,Adj.ServiceTaxSurChgAmt,PT.PName PName,adj.ClaimNo,adj.PanelAppRemarks,adj.PanelApprovedAmt, ";
        strQ += "                       adj.PanelApprovalDate,adj.DiscountOnBillReason,adj.ApprovalBy,adj.IsBilledClosed, ";
        strQ += "                       pmh.PolicyNo,pmh.CardNo,pmh.DoctorID,pmh.PanelID FROM ( ";
        strQ += "                             SELECT BillNo,TransactionID,Billdate FROM f_ledgertransaction WHERE IsCancel = 0 ";

        if (CompType == "1")
        {
            if (TypeofTnx == "BillDate")
                strQ += "                             and Date(BillDate) = '" + Util.GetDateTime(ID).ToString("yyyy-MM-dd") + "' ";
            else
                strQ += "                             and Date(BillDate) >= '" + DateFrom + "' and Date(BillDate) <= '" + DateTo + "'";
        }
        else
        {
            if (TypeofTnx == "BillDate")
                strQ += "                             and Date(BillDate) = '" + Util.GetDateTime(ID).ToString("yyyy-MM-dd") + "' ";
            else
                strQ += "                             and Date(BillDate) >= '" + DateFromC + "' and Date(BillDate) <= '" + DateToC + "'";
        }

        strQ += "                             GROUP BY BillNo ";
        strQ += "                       )lt INNER JOIN f_ipdadjustment adj ON adj.TransactionID = lt.TransactionID ";
        strQ += "                       INNER JOIN patient_master pt ON pt.PatientID = adj.PatientID ";
        strQ += "                       INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ";
        strQ += "                       WHERE (Adj.BillNo IS NOT NULL) AND Adj.BillNo <> ''  ";

        if (TypeofTnx == "DoctorID")
            strQ += "                       AND pmh.DoctorID='" + ID + "' ";
        if (TypeofTnx == "PanelID")
            strQ += "                       AND pmh.PanelID=" + ID + " ";

        strQ += "                   )Temp1 ";
        strQ += "                   UNION ALL ";
        strQ += "                   SELECT '' BillingType,BC.BillNo,BC.BillDate,BC.PatientID,BC.TransactionID,0.0 TotalBilledAmt, ";
        strQ += "                   0.0 DiscountOnBill, 0.0 AdjustmentAmt,0.0 ReceiveAmt,0.0 ItemWiseDiscount, ";
        strQ += "                   BC.BillGenerateUserID,0.0 TDS,0.0 Deduction_Acceptable,0.0 Deduction_NonAcceptable,0.0 WriteOff,0.0 CreditAmt,0.0 DebitAmt,0.0 ServiceTaxAmt,0.0 ServiceTaxSurChgAmt,CONCAT(PT.Pname,'---CANCEL')PNAME,'' ClaimNo,''PanelAppRemarks,  ";
        strQ += "                   ''PanelApprovedAmt,''PanelApprovalDate,''DiscountOnBillReason,''ApprovalBy,'0' IsBilledClosed,  ";
        strQ += "                   '' PolicyNo,'' CardNo,'' DoctorID,'' PanelID ";
        strQ += "                   FROM f_billcancellation BC INNER JOIN patient_master PT ON BC.PatientID = PT.PatientID ";
        strQ += "               ) T1  ";
        strQ += "               INNER JOIN Doctor_Master dm ON dm.DoctorID = T1.DoctorID ";
        strQ += "               INNER JOIN employee_master EM ON EM.Employee_ID = T1.UserID ";
        strQ += "               LEFT OUTER JOIN f_panel_master PM ON PM.PanelID = T1.PanelID ";

        if (CompType == "1")
        {
            if (TypeofTnx == "BillDate")
                strQ += "                             Where Date(BillDate) = '" + Util.GetDateTime(ID).ToString("yyyy-MM-dd") + "' ";
            else
                strQ += "                             Where Date(BillDate) >= '" + DateFrom + "' and Date(BillDate) <= '" + DateTo + "'";
        }
        else
        {
            if (TypeofTnx == "BillDate")
                strQ += "                             Where Date(BillDate) = '" + Util.GetDateTime(ID).ToString("yyyy-MM-dd") + "' ";
            else
                strQ += "                             Where Date(BillDate) >= '" + DateFromC + "' and Date(BillDate) <= '" + DateToC + "'";
        }

        //For Specialization
        if (TypeofTnx == "Specialization")
            strQ += "               AND dm.Specialization = '" + ID + "' ";

        strQ += "        )T2";
        strQ += "    )T3";
        strQ += ")T4 left join ipd_case_History ich on ich.TransactionID = T4.TransactionID ";
        strQ += " order by Billno";

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();

            ((Label)grdDetails.FooterRow.FindControl("lblGrossBillAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(GrossBillAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDiscountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDiscount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetBillAmountT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(NetBillAmount)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalDepositT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalDeposit)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTotalRefundT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TotalRefund)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblReceiveAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ReceiveAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblOutStandingT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(OutStanding)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblTDST")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(TDS)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDeductionAcceptableT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(DeductionAcceptable)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDeductionNonAcceptableT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(DeductionNonAcceptable)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblWriteOffT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(WriteOff)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblCreditAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(CreditAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDebitAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(DebitAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblServiceTaxAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ServiceTaxAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblServiceTaxSurChgAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(ServiceTaxSurChgAmt)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblPanelApprovedAmtT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(PanelApprovedAmt)", ""))));

        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }
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
            {
                e.Row.BackColor =System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblDocQtyGrowthOpenBill")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblDocQtyGrowthPkgBill")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblDocQtyGrowthMixedBill")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
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

                if (((Label)e.Row.FindControl("lblSpecQtyGrowthOpenBill")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSpecQtyGrowthPkgBill")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblSpecQtyGrowthMixedBill")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[5].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");
            }     

            
        }
    }
    protected void grdBillDateC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblCompBillDate")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#C0FFFF");
            }
            else if (((Label)e.Row.FindControl("lblCompBillDate")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFC0");
            }

            else if (((Label)e.Row.FindControl("lblCompBillDate")).Text == "3")
            {
                e.Row.BackColor = System.Drawing.Color.White;

                if (((Label)e.Row.FindControl("lblBillDateQtyGrowthOpenBill")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblBillDateQtyGrowthPkgBill")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblBillDateQtyGrowthMixedBill")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
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

                if (((Label)e.Row.FindControl("lblPanelQtyGrowthOpenBill")).Text == "Y")
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[2].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblPanelQtyGrowthPkgBill")).Text == "Y")
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[3].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

                if (((Label)e.Row.FindControl("lblPanelQtyGrowthMixedBill")).Text == "Y")
                    e.Row.Cells[4].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
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
                LoadDocDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), DocID, CompType);
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
                LoadItemDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), ItemID, CompType);
                mpSelect.Show();
            }
        }
    }
    protected void grdBillDateC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string SubCategoryID = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            string CompType = Util.GetString(e.CommandArgument).Split('#')[1].ToString();
            if (CompType != "3")
            {
                LoadSubCatDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), SubCategoryID, CompType);
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
                LoadPanelDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), PanelID, CompType);
                mpSelect.Show();
            }
        }
    }

    
}
