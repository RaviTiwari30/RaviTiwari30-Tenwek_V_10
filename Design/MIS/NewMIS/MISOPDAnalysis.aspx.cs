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

public partial class Design_MIS_MISOPD : System.Web.UI.Page
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


            switch (SelectionType)
            {
                case "OPD-CONSULTATION":
                    ViewState["TypeofTnx"] = "'OPD-Appointment'";
                    ViewState["ConfigIDs"] = "5";
                    break;
                case "OPD-INVESTIGATIONS":
                    ViewState["TypeofTnx"] = "'OPD-LAB','OPD-BILLING'";
                    ViewState["ConfigIDs"] = "3";
                    break;
                case "OPD-MINOR PROCEDURES":
                    ViewState["TypeofTnx"] = "'OPD-PROCEDURE','OPD-BILLING'";
                    ViewState["ConfigIDs"] = "25,7";
                    break;
                case "OPD-PACKAGE":
                    ViewState["TypeofTnx"] = "'OPD-PACKAGE'";
                    ViewState["ConfigIDs"] = "23";
                    break;
                case "OPD-BILLING":
                    ViewState["TypeofTnx"] = "'OPD-BILLING'";
                    ViewState["ConfigIDs"] = "3,6,20,11,23";
                    break;
                case "OPD-OTHER MISC":
                    ViewState["TypeofTnx"] = "'OPD-OTHERS','OPD-BILLING'";
                    ViewState["ConfigIDs"] = "6,20,11,0";
                    break;
                case "ALL OPD":
                    ViewState["TypeofTnx"] = "'ALL'";
                    ViewState["ConfigIDs"] = "";
                    break;

                default:
                    break;
            }
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
        
        if (ViewState["SelectionType"] != null && ViewState["SelectionType"].ToString() == "OPD-CONSULTATION")
            LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days + 1), Util.GetString(ts2.Days + 1), ViewState["DateType"].ToString(), ViewState["TypeofTnx"].ToString(), "OPD", ViewState["ConfigIDs"].ToString(), ViewState["SelectionType"].ToString());
        else if (ViewState["SelectionType"] != null && ViewState["SelectionType"].ToString() == "OPD-INVESTIGATIONS")
            LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days + 1), Util.GetString(ts2.Days + 1), ViewState["DateType"].ToString(), ViewState["TypeofTnx"].ToString(), "OPD", ViewState["ConfigIDs"].ToString(), ViewState["SelectionType"].ToString());
        else if (ViewState["SelectionType"] != null && ViewState["SelectionType"].ToString() == "OPD-MINOR PROCEDURES")
            LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days + 1), Util.GetString(ts2.Days + 1), ViewState["DateType"].ToString(), ViewState["TypeofTnx"].ToString(), "OPD", ViewState["ConfigIDs"].ToString(), "OPD-MINOR PROCEDURES");
        else if (ViewState["SelectionType"] != null && ViewState["SelectionType"].ToString() == "OPD-PACKAGES")
            LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days + 1), Util.GetString(ts2.Days + 1), ViewState["DateType"].ToString(), ViewState["TypeofTnx"].ToString(), "OPD", ViewState["ConfigIDs"].ToString(), ViewState["SelectionType"].ToString());
        else if (ViewState["SelectionType"] != null && ViewState["SelectionType"].ToString() == "OPD-OTHER MISC")
            LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days + 1), Util.GetString(ts2.Days + 1), ViewState["DateType"].ToString(), ViewState["TypeofTnx"].ToString(), "OPD", ViewState["ConfigIDs"].ToString(), "OPD OTHER MISC");
        else if (ViewState["SelectionType"] != null && ViewState["SelectionType"].ToString() == "ALL OPD")
            LoadComparisonData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), Util.GetDateTime(txtFromDateC.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(txtToDateC.Text).ToString("yyyy-MM-dd"), Util.GetString(ts1.Days+1), Util.GetString(ts2.Days+1), ViewState["DateType"].ToString(), ViewState["TypeofTnx"].ToString(), "OPD", "", "ALL OPD");

        lblDocC.Visible = true;
        lblGroupC.Visible = true;
        lblItemwiseC.Visible = true;
        lblPanelC.Visible = true;

    }

    private void LoadComparisonData(string DateFrom, string DateTo, string CompDateFrom, string CompDateTo, string Days1, string Days2, string DateType, string TypeofTnx, string OPDIPD, string ConfigIds, string SelectionType)
    {
        if (OPDIPD == "OPD")
        {
            if (TypeofTnx.ToUpper() == "'ALL'")
            {
                LoadComparisonALLOPD(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, TypeofTnx);                
            }
            else if (TypeofTnx.ToUpper() == "'OPD-APPOINTMENT'")
            {
                LoadComparisonOPDAppointment(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, TypeofTnx);                
            }
            else
            {
                LoadComparisonOPDData(DateFrom, DateTo, CompDateFrom, CompDateTo, Days1, Days2, TypeofTnx,ConfigIds);                
            }
            
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["TypeofTnx"] = TypeofTnx;
            ViewState["SelectionType"] = SelectionType;
        }
    }

    private void LoadComparisonALLOPD(string DateFrom, string DateTo, string DateFromC, string DateToC, string Days1, string Days2, string TypeofTnx)
    {
        string strQ = "";

        //For Doctor-wise
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,DoctorID,CompType,'N' Growth from ( ";
        strQ += "       SELECT dm.Name,t.Qty,t.Gross,t.Disc,t.Net,t.Collected,dm.DoctorID,CompType ";
        strQ += "       FROM (";
        strQ += "               SELECT TransactionID,ROUND(SUM(Quantity),2)Qty,";
        strQ += "               ROUND(SUM(Rate*Quantity))Gross,ROUND(SUM(Rate*Quantity)-SUM(Amount))Disc,";
        strQ += "               ROUND(SUM(Amount))Net,ROUND(SUM(Collected))Collected,SubCategory,Type_ID,CompType FROM(";
        strQ += "                       SELECT ltd.TransactionID,Rate,Quantity,Amount,";
        strQ += "                       IFNULL(rt.AmountPaid,0)Collected, sc.Name SubCategory,im.Type_ID,lt.Date, ";
        strQ += "                       if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "                       INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "                       LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "                       WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-Appointment') ";
        strQ += "                       AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "                       OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "               )t GROUP BY Type_ID,CompType ";
        strQ += "       )t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID";
        strQ += "       UNION ALL ";
        strQ += "       SELECT NAME,ROUND(SUM(Qty))Qty,ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(IFNULL(Collected,0)))Collected,t1.DoctorID,CompType FROM( ";
        strQ += "               SELECT dm.Name,dm.DoctorID,ROUND(SUM(Quantity),2)Qty, ROUND(SUM(Gross))Gross, ";
        strQ += "               ROUND(SUM(Disc))Disc,ROUND(SUM(Net))Net,(SELECT IFNULL(AmountPaid,0) ";
        strQ += "               FROM f_reciept WHERE AsainstLedgerTnxNo = t.LedgerTransactionNo AND IsCancel=0)Collected,CompType ";
        strQ += "               FROM ( ";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity,(Rate*Quantity)Gross, ";
        strQ += "                       ((Rate*Quantity)-(Amount))Disc, ";
        strQ += "                       if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType, ";
        strQ += "                       (Amount)Net,lt.LedgerTransactionNo,lt.Date FROM f_ledgertransaction lt ";
        strQ += "                       INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo WHERE lt.IsCancel = 0 ";
        strQ += "                       AND lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        strQ += "                       AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "                       OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "               )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "               INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        strQ += "               GROUP BY t.TransactionID,CompType ";
        strQ += "       )t1  GROUP BY t1.DoctorID,CompType ";
        strQ += ")t2 group by DoctorID,CompType ORDER BY NAME,CompType ";
        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            dt = MergeExtraRows(dt, "DoctorID", rbtViewType.SelectedValue,Days1,Days2);
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
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,ItemID,CompType,'N' Growth from (   ";
        strQ += "       SELECT dm.Specialization Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,dm.Specialization ItemID,CompType ";
        strQ += "       FROM (";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "               Amount Net,im.Type_ID,ifnull(rt.AmountPaid,0)Collected, ";
        strQ += "               if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "               LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-APPOINTMENT') ";
        strQ += "               AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "               OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "       )t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID  GROUP BY dm.Specialization,CompType ";
        strQ += "       UNION ALL ";
        strQ += "       SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,ItemID,CompType FROM ( ";
        strQ += "               SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "               IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,ItemID,CompType ";
        strQ += "               FROM ( ";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity, ";
        strQ += "                       (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "                       (Amount)Net,ltd.ItemID,im.typeName NAME ,IFNULL((SELECT AmountPaid ";
        strQ += "                       FROM f_reciept WHERE ";
        strQ += "                       AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "                       (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "                       WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt, ";
        strQ += "                       if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "                       WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
        strQ += "                       AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "                       OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "               )t ";
        strQ += "       )t1 GROUP BY ItemID,CompType  ";
        strQ += ")t2 Group by ItemID,CompType ORDER BY NAME,CompType";

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

        //For SubCategory-wise

        strQ = "";
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,SubCategoryID,CompType,'N' Growth from (   ";
        strQ += "       SELECT Name,ROUND(SUM(Quantity),2)Qty,";
        strQ += "       ROUND(SUM(Rate*Quantity))Gross,ROUND(SUM(Rate*Quantity)-SUM(Amount))Disc,";
        strQ += "       ROUND(SUM(Amount))Net,ROUND(SUM(Collected))Collected,SubCategoryID,CompType FROM (";
        strQ += "               SELECT sc.Name,Rate,Quantity,Amount,";
        strQ += "               ifnull(rt.AmountPaid,0)Collected,im.SubCategoryID, ";
        strQ += "               if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "               LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-APPOINTMENT') ";
        strQ += "               AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "               OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "       )t GROUP BY SubCategoryID,CompType ";
        strQ += "       UNION ALL ";
        strQ += "       SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,SubCategoryID,CompType FROM ( ";
        strQ += "               SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "               IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,SubCategoryID,CompType ";
        strQ += "               FROM ( ";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity,ltd.SubCategoryID, ";
        strQ += "                       (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "                       (Amount)Net,ltd.ItemID,sc.NAME ,IFNULL((SELECT AmountPaid ";
        strQ += "                       FROM f_reciept WHERE ";
        strQ += "                       AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "                       (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "                       WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt, ";
        strQ += "                       if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "                       INNER JOIN f_SubCategoryMaster sc ON im.SubCategoryID = sc.SubCategoryID ";
        strQ += "                       WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
        strQ += "                       AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "                       OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "               )t ";
        strQ += "       )t1 GROUP BY SubCategoryID,CompType ";
        strQ += ")T2 Group By SubCategoryID,CompType order by Name,CompType ";
        dt = StockReports.GetDataTable(strQ);

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

        strQ = "";
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,PanelID,CompType,'N' Growth from (   ";
        strQ += "       SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,pmh.PanelID,CompType ";
        strQ += "       FROM (";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "               Amount Net,ifnull(rt.AmountPaid,0) Collected, ";
        strQ += "               if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-APPOINTMENT') ";
        strQ += "               AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "               OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "       )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "       INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY pmh.PanelID";
        strQ += "       UNION ALL ";
        strQ += "       SELECT Name,ROUND(SUM(Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,PanelID,CompType from ( ";
        strQ += "               SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "               ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "               ROUND(SUM(Net))Net,IFNULL((Select AmountPaid from f_reciept where ";
        strQ += "               AsainstLedgerTnxNo = t.LedgerTransactionNo and IsCancel=0 ),0)Collected,pmh.PanelID,CompType ";
        strQ += "               FROM (";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "                       (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "                       Amount Net,lt.LedgerTransactionNo, ";
        strQ += "                       if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
        strQ += "                       AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "                       OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "               )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "               INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY t.LedgerTransactionNo,CompType";
        strQ += "       )t1 Group by PanelID,CompType ";
        strQ += ")t2 Group by PanelID,CompType order by Name,CompType ";
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

    private void LoadComparisonOPDAppointment(string DateFrom, string DateTo, string DateFromC, string DateToC, string Days1, string Days2, string TypeofTnx)
    {
        string strQ = "";


        //For Doctor-wise

        strQ += "SELECT dm.Name,dm.Specialization,t.Qty,t.Gross,t.Disc,t.Net,t.Collected,dm.DoctorID,CompType,'N' Growth ";
        strQ += "FROM (";
        strQ += "   SELECT t.TransactionID,ROUND(SUM(t.Quantity),2)Qty,";
        strQ += "   ROUND(SUM(t.Rate*t.Quantity))Gross,ROUND(SUM(t.Rate*t.Quantity)-SUM(t.Amount))Disc,";
        strQ += "   ROUND(SUM(t.Amount))Net,ROUND(SUM(Collected))Collected,SubCategory,Type_ID,CompType From ( ";
        strQ += "           SELECT ltd.TransactionID,ltd.Quantity,";
        strQ += "           ltd.Rate,ltd.Amount,";
        strQ += "           IFNULL(rt.AmountPaid,0)Collected, sc.Name SubCategory,im.Type_ID, ";
        strQ += "           if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "           FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "           ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "           INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "           INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "           LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "           WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "           AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "           OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "   )t GROUP BY t.Type_ID,CompType ";
        strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID";
        strQ += " order by Name,CompType ";
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
        strQ += "SELECT dm.Specialization Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,dm.Specialization ItemID,CompType,'N' Growth ";
        strQ += "FROM (";
        strQ += "    SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "    (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "    Amount Net,im.Type_ID,ifnull(rt.AmountPaid,0)Collected, ";
        strQ += "    if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "    ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "    INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "   LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "   WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "   AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "   OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID  GROUP BY dm.Specialization,CompType ";
        strQ += " order by Specialization,CompType ";
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

        //For SubCategory-wise

        strQ = "";
        strQ += "    SELECT Name,ROUND(SUM(Quantity),2)Qty,";
        strQ += "    ROUND(SUM(Rate*Quantity))Gross,ROUND(SUM(Rate*Quantity)-SUM(Amount))Disc,";
        strQ += "    ROUND(SUM(Amount))Net,ROUND(SUM(Collected))Collected,SubCategoryID,CompType,'N' Growth From (";
        strQ += "           SELECT sc.Name,";
        strQ += "           ltd.Rate,ltd.Quantity,";
        strQ += "           ltd.Amount,ifnull(rt.AmountPaid,0) Collected,im.SubCategoryID,  ";
        strQ += "           if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "           FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "           ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "           INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "           INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "           LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "           WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "           AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "           OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "            AND DATE(lt.Date)<='" + DateTo + "'  ";
        strQ += "     )t GROUP BY SubCategoryID,CompType";
        strQ += "   order by Name,CompType ";
        dt = StockReports.GetDataTable(strQ);

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

        strQ = "";
        strQ += "SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,pmh.PanelID,CompType,'N' Growth ";
        strQ += "FROM (";
        strQ += "    SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "    (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "    Amount Net,ifnull(rt.AmountPaid,0) Collected, ";
        strQ += "    if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "    ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "    LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "    WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "    AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "    OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += ")t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += " INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY pmh.PanelID,CompType ";
        strQ += " order by Name,CompType ";
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

    private void LoadComparisonOPDData(string DateFrom, string DateTo, string DateFromC, string DateToC, string Days1, string Days2, string TypeofTnx, string ConfigIDs)
    {
        string strQ = "";

        //For Doctor-wise

        strQ += "SELECT NAME,ROUND(SUM(Qty))Qty,ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(IFNULL(Collected,0)))Collected,t1.DoctorID,CompType,'N' Growth FROM( ";
        strQ += "    SELECT dm.Name,dm.DoctorID,ROUND(SUM(Quantity),2)Qty, ROUND(SUM(Gross))Gross, ";
        strQ += "    ROUND(SUM(Disc))Disc,ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected, ";        
        strQ += "    CompType FROM ( ";
        strQ += "       SELECT TransactionID,Quantity,Gross,Disc,Net,LedgerTransactionNo, ";
        strQ += "       IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,CompType from (";
        strQ += "           SELECT ltd.TransactionID,ltd.Quantity,(Rate*Quantity)Gross, ";
        strQ += "           ((Rate*Quantity)-(Amount))Disc,IFNULL((SELECT AmountPaid ";
        strQ += "           FROM f_reciept WHERE ";
        strQ += "           AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "           (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "           WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt, ";
        strQ += "           if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType, ";
        strQ += "           (Amount)Net,lt.LedgerTransactionNo FROM f_ledgertransaction lt ";
        strQ += "           INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "           ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo WHERE lt.IsCancel = 0 ";
        strQ += "           AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "           AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "           AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "           OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "       )t1 ";
        strQ += "    )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        strQ += "    GROUP BY t.TransactionID,CompType ";
        strQ += ")t1  GROUP BY t1.DoctorID,CompType ";
        strQ += "ORDER BY NAME,CompType ";

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


        //For Itemwise-wise
        strQ = "";

        strQ += "SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,ItemID,CompType,'N' Growth FROM ( ";
        strQ += "       SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "       IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,ItemID,CompType ";
        strQ += "       FROM ( ";        
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity, ";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "               (Amount)Net,ltd.ItemID,im.typeName NAME ,IFNULL((SELECT AmountPaid ";
        strQ += "               FROM f_reciept WHERE ";
        strQ += "               AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "               (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "               WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt, ";
        strQ += "               if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "               AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "               AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "               OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "       )t ";
        strQ += ")t1 GROUP BY ItemID,CompType ORDER BY NAME,CompType ";


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

        //For SubCategory-wise

        strQ = "";
        strQ += "SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,SubCategoryID,CompType,'N' Growth FROM ( ";
        strQ += "       SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "       IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,SubCategoryID,CompType ";
        strQ += "       FROM ( ";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity,ltd.SubCategoryID, ";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "               (Amount)Net,ltd.ItemID,sc.NAME ,IFNULL((SELECT AmountPaid ";
        strQ += "               FROM f_reciept WHERE ";
        strQ += "               AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "               (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "               WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt, ";
        strQ += "               if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               INNER JOIN f_SubCategoryMaster sc ON im.SubCategoryID = sc.SubCategoryID ";
        strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "               AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "               AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "               OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "       )t ";
        strQ += ")t1 GROUP BY SubCategoryID,CompType ORDER BY NAME,CompType ";
        dt = StockReports.GetDataTable(strQ);

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

        strQ = "";
        strQ += "SELECT Name,ROUND(SUM(Qty),2)Qty,";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,PanelID,CompType,'N' Growth from ( ";
        strQ += "       SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,pmh.PanelID,CompType ";
        strQ += "       FROM (";
        strQ += "           SELECT TransactionID,Qty,Gross,Disc,Net,LedgerTransactionNo, ";
        strQ += "           IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,BillAmt,CompType from (";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "               Amount Net,lt.LedgerTransactionNo,IFNULL((SELECT AmountPaid ";
        strQ += "               FROM f_reciept WHERE ";
        strQ += "               AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "               (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "               WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt, ";
        strQ += "               if((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "'),1,2)CompType ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "               AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "               AND ((DATE(lt.Date) between '" + DateFrom + "' AND '" + DateTo + "')  ";
        strQ += "               OR (DATE(lt.Date) between '" + DateFromC + "' AND '" + DateToC + "')) ";
        strQ += "           )t1 ";
        strQ += "       )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "       INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY t.LedgerTransactionNo";
        strQ += ")t1 Group by PanelID,CompType order by Name,CompType ";
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

    private void LoadDocDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string DocID, string CompType,string ConfigIDs)
    {
        string strQ = "";
        if (TypeofTnx.ToUpper() == "'ALL'")
        {
            strQ = "Select Date,MR_No,PName,Age,Gender,DocName,Panel,Specialization,ReceiptNo,Gross,Disc,Net,Collected,LedgerTransactionNo FROM (  ";
            strQ += "       SELECT t.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,pm.Age,pm.Gender,DocName,Panel, ";
            strQ += "       Specialization,IF(rt.ReceiptNo IS NULL,t.BillNo,rt.ReceiptNo)ReceiptNo,Gross,Disc,Net, ";
            strQ += "       IFNULL((AmountPaid),0)Collected,t.LedgerTransactionNo FROM ( ";
            strQ += "               SELECT lt.TransactionID,lt.PatientID,dm.Name DocName,pnl.Company_Name Panel, ";
            strQ += "               dm.Specialization,ROUND(SUM(ltd.Rate*ltd.Quantity))Gross, ";
            strQ += "               ROUND(SUM((ltd.Rate*ltd.Quantity)-Amount))Disc,ROUND(SUM(ltd.Amount))Net, ";
            strQ += "               DATE_FORMAT(lt.date,'%d-%b-%y')DATE,lt.LedgerTransactionNo,lt.BillNo ";
            strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ";
            strQ += "               lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN f_itemmaster im ON  ";
            strQ += "               ltd.ItemID = im.ItemID INNER JOIN doctor_master dm ON dm.DoctorID = im.Type_ID ";
            strQ += "               INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ";
            strQ += "               INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
            strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-APPOINTMENT') ";

            if (CompType == "1")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateTo + "' AND dm.DoctorID='" + DocID + "' ";
            }
            else if (CompType == "2")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFromC + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateToC + "' AND dm.DoctorID='" + DocID + "' ";
            }

            strQ += "               GROUP BY ltd.LedgerTransactionNo ";
            strQ += "       )t INNER JOIN patient_master pm ON t.PatientID= pm.PatientID ";
            strQ += "       LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = t.LedgerTransactionNo ";
            strQ += "       UNION ALL ";
            strQ += "       SELECT t.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,pm.Age,pm.Gender,DocName,Panel, ";
            strQ += "       Specialization,IF(rt.ReceiptNo IS NULL,t.BillNo,rt.ReceiptNo)ReceiptNo,Gross,Disc,Net, ";
            strQ += "       IFNULL((AmountPaid),0)Collected,t.LedgerTransactionNo FROM ( ";
            strQ += "               SELECT lt.TransactionID,lt.PatientID,dm.Name DocName,pnl.Company_Name Panel, ";
            strQ += "               dm.Specialization,ROUND(SUM(ltd.Rate*ltd.Quantity))Gross, ";
            strQ += "               ROUND(SUM((ltd.Rate*ltd.Quantity)-Amount))Disc,ROUND(SUM(ltd.Amount))Net, ";
            strQ += "               DATE_FORMAT(lt.date,'%d-%b-%y')DATE,lt.LedgerTransactionNo,lt.BillNo ";
            strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ";
            strQ += "               lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ";
            strQ += "               INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ";
            strQ += "               INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
            strQ += "               INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
            strQ += "               WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
            if (CompType == "1")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateTo + "' AND dm.DoctorID='" + DocID + "' ";
            }
            else if (CompType == "2")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFromC + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateToC + "' AND dm.DoctorID='" + DocID + "' ";
            }
            strQ += "               GROUP BY ltd.LedgerTransactionNo ";
            strQ += "       )t INNER JOIN patient_master pm ON t.PatientID= pm.PatientID ";
            strQ += "       LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = t.LedgerTransactionNo ";
            strQ += ")t2 order by ReceiptNo ";
            DataTable dt = StockReports.GetDataTable(strQ);

            if (dt != null && dt.Rows.Count > 0)
            {
                grdDetails.DataSource = dt;
                grdDetails.DataBind();

                ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            }
            else
            {
                grdDetails.DataSource = null;
                grdDetails.DataBind();
            }
        }
        else if (TypeofTnx.ToUpper() == "'OPD-APPOINTMENT'")
        {

            strQ += "SELECT t.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,pm.Age,pm.Gender,DocName,Panel, ";
            strQ += "Specialization,IF(rt.ReceiptNo IS NULL,t.BillNo,rt.ReceiptNo)ReceiptNo,Gross,Disc,Net, ";
            strQ += "IFNULL((AmountPaid),0)Collected,t.LedgerTransactionNo FROM ( ";
            strQ += "    SELECT lt.TransactionID,lt.PatientID,dm.Name DocName,pnl.Company_Name Panel, ";
            strQ += "    dm.Specialization,ROUND(SUM(ltd.Rate*ltd.Quantity))Gross, ";
            strQ += "    ROUND(SUM((ltd.Rate*ltd.Quantity)-Amount))Disc,ROUND(SUM(ltd.Amount))Net, ";
            strQ += "    DATE_FORMAT(lt.date,'%d-%b-%y')DATE,lt.LedgerTransactionNo,lt.BillNo ";
            strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ";
            strQ += "    lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN f_itemmaster im ON  ";
            strQ += "    ltd.ItemID = im.ItemID INNER JOIN doctor_master dm ON dm.DoctorID = im.Type_ID ";
            strQ += "    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ";
            strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
            strQ += "    WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
            if (CompType == "1")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateTo + "' AND dm.DoctorID='" + DocID + "' ";
            }
            else if (CompType == "2")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFromC + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateToC + "' AND dm.DoctorID='" + DocID + "' ";
            }
            strQ += "    GROUP BY ltd.LedgerTransactionNo ";
            strQ += ")t INNER JOIN patient_master pm ON t.PatientID= pm.PatientID ";
            strQ += "LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = t.LedgerTransactionNo ";

            DataTable dt = StockReports.GetDataTable(strQ);

            if (dt != null && dt.Rows.Count > 0)
            {
                grdDetails.DataSource = dt;
                grdDetails.DataBind();

                ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            }
            else
            {
                grdDetails.DataSource = null;
                grdDetails.DataBind();
            }
        }
        else
        {
            strQ += "SELECT t.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,pm.Age,pm.Gender,DocName,Panel, ";
            strQ += "Specialization,IF(rt.ReceiptNo IS NULL,t.BillNo,rt.ReceiptNo)ReceiptNo,Gross,Disc,Net, ";
            strQ += "IFNULL((AmountPaid),0)Collected,t.LedgerTransactionNo FROM ( ";
            strQ += "    SELECT lt.TransactionID,lt.PatientID,dm.Name DocName,pnl.Company_Name Panel, ";
            strQ += "    dm.Specialization,ROUND(SUM(ltd.Rate*ltd.Quantity))Gross, ";
            strQ += "    ROUND(SUM((ltd.Rate*ltd.Quantity)-Amount))Disc,ROUND(SUM(ltd.Amount))Net, ";
            strQ += "    DATE_FORMAT(lt.date,'%d-%b-%y')DATE,lt.LedgerTransactionNo,lt.BillNo ";
            strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ";
            strQ += "    lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ";
            strQ += "    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ";
            strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
            strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
            strQ += "    WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN(" + TypeofTnx + ") ";
            if (CompType == "1")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateTo + "' AND dm.DoctorID='" + DocID + "' ";
            }
            else if (CompType == "2")
            {
                strQ += "               AND DATE(lt.Date)>='" + DateFromC + "' ";
                strQ += "               AND DATE(lt.Date)<='" + DateToC + "' AND dm.DoctorID='" + DocID + "' ";
            }

            strQ += "   ltd.ConfigID in (" + ConfigIDs + ")";

            strQ += "    GROUP BY ltd.LedgerTransactionNo ";
            strQ += ")t INNER JOIN patient_master pm ON t.PatientID= pm.PatientID ";
            strQ += "LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = t.LedgerTransactionNo ";

            DataTable dt = StockReports.GetDataTable(strQ);

            if (dt != null && dt.Rows.Count > 0)
            {
                grdDetails.DataSource = dt;
                grdDetails.DataBind();

                ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            }
            else
            {
                grdDetails.DataSource = null;
                grdDetails.DataBind();
            }
        }
    }

    private void LoadItemDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string ItemID, string CompType,string ConfigIDs)
    {
        string strQ = "";

        strQ += "SELECT t1.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,";
        strQ += "pm.Age,pm.Gender,DocName,Panel,Specialization,ReceiptNo,";
        strQ += "Gross,Round(Disc)Disc,Round(Net)Net,Round(Collected)Collected,LedgerTransactionNo FROM (";
        strQ += "    SELECT t.NAME,Quantity Qty,Gross,Disc,Net, t.Date,";
        strQ += "    IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,t.TransactionID,t.ItemID,";
        strQ += "    dm.Name DocName,pnl.Company_Name Panel,dm.Specialization,ReceiptNo,pmh.PatientID,LedgerTransactionNo ";
        strQ += "    FROM ( ";
        strQ += "        SELECT ltd.TransactionID,ltd.Quantity,DATE_FORMAT(lt.date,'%d-%b-%y')DATE,";
        strQ += "        (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "        (Amount)Net,ltd.ItemID,im.typeName NAME ,IFNULL(AmountPaid,0)Collected, ";
        strQ += "        (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "        WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,";
        strQ += "        IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)ReceiptNo,lt.LedgerTransactionNo ";
        strQ += "        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "        ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "        INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "        LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "        AND rt.IsCancel=0 ";
        strQ += "        WHERE lt.IsCancel = 0  ";

        if (TypeofTnx.ToUpper() == "'ALL'")
            strQ += "        AND lt.TypeOfTnx IN('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        else
            strQ += "        AND lt.TypeOfTnx IN(" + TypeofTnx + ")  ";

        if (TypeofTnx.ToUpper() != "'ALL'")
            strQ += "        AND ltd.ConfigID IN(" + ConfigIDs + ")  ";

        if (CompType == "1")
        {
            strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateTo + "'  ";
        }
        else if (CompType == "2")
        {
            strQ += "               AND DATE(lt.Date)>='" + DateFromC + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateToC + "' ";
        }

        strQ += "    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        if (TypeofTnx.ToUpper() == "'OPD-APPOINTMENT'")
            strQ += "    WHERE dm.Specialization='" + ItemID + "' ";
        else
            strQ += "    WHERE t.ItemID='" + ItemID + "' ";

        strQ += ")t1 INNER JOIN patient_master pm ON t1.PatientID= pm.PatientID ";

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();

            ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }

    }

    private void LoadSubCatDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string SubCategoryID, string CompType, string ConfigIDs)
    {
        string strQ = "";

        strQ += "SELECT t1.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,";
        strQ += "pm.Age,pm.Gender,DocName,Panel,Specialization,ReceiptNo,";
        strQ += "Gross,Round(Disc)Disc,Round(Net)Net,Round(Collected)Collected,LedgerTransactionNo FROM (";
        strQ += "    SELECT t.NAME,Quantity Qty,Gross,Disc,Net, t.Date,";
        strQ += "    IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,t.TransactionID,t.ItemID,";
        strQ += "    dm.Name DocName,pnl.Company_Name Panel,dm.Specialization,ReceiptNo,pmh.PatientID,LedgerTransactionNo ";
        strQ += "    FROM ( ";
        strQ += "        SELECT ltd.TransactionID,ltd.Quantity,DATE_FORMAT(lt.date,'%d-%b-%y')DATE,";
        strQ += "        (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "        (Amount)Net,ltd.ItemID,ltd.ItemName NAME ,IFNULL(AmountPaid,0)Collected, ";
        strQ += "        (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "        WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,";
        strQ += "        IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)ReceiptNo,ltd.SubCategoryID,lt.LedgerTransactionNo ";
        strQ += "        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "        ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "        LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "        AND rt.IsCancel=0 ";
        strQ += "        WHERE lt.IsCancel = 0 ";

        if (TypeofTnx.ToUpper() == "'ALL'")
            strQ += "        AND lt.TypeOfTnx IN('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        else
            strQ += "        AND lt.TypeOfTnx IN(" + TypeofTnx + ")  ";

        if (TypeofTnx.ToUpper() != "'ALL'")
            strQ += "        AND ltd.ConfigID IN(" + ConfigIDs + ")  ";

        if (CompType == "1")
        {
            strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateTo + "'  ";
        }
        else if (CompType == "2")
        {
            strQ += "               AND DATE(lt.Date)>='" + DateFromC + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateToC + "' ";
        }

        strQ += "    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        strQ += "    WHERE t.SubCategoryID='" + SubCategoryID + "' ";
        strQ += ")t1 INNER JOIN patient_master pm ON t1.PatientID= pm.PatientID ";

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();

            ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }

    }

    private void LoadPanelDetailCompData(string DateFrom, string DateTo, string DateFromC, string DateToC, string TypeofTnx, string PanelID, string CompType, string ConfigIDs)
    {
        string strQ = "";

        strQ += "SELECT t1.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,";
        strQ += "pm.Age,pm.Gender,DocName,Panel,Specialization,ReceiptNo,";
        strQ += "Gross,Round(Disc)Disc,Round(Net)Net,Round(Collected)Collected,LedgerTransactionNo FROM (";
        strQ += "    SELECT t.NAME,Quantity Qty,Gross,Disc,Net, t.Date,";
        strQ += "    IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,t.TransactionID,t.ItemID,";
        strQ += "    dm.Name DocName,pnl.Company_Name Panel,dm.Specialization,ReceiptNo,pmh.PatientID,LedgerTransactionNo ";
        strQ += "    FROM ( ";
        strQ += "        SELECT ltd.TransactionID,ltd.Quantity,DATE_FORMAT(lt.date,'%d-%b-%y')DATE,";
        strQ += "        (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "        (Amount)Net,ltd.ItemID,ltd.ItemName NAME ,IFNULL(AmountPaid,0)Collected, ";
        strQ += "        (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "        WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,";
        strQ += "        IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)ReceiptNo,ltd.SubCategoryID,lt.LedgerTransactionNo ";
        strQ += "        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "        ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "        LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "        AND rt.IsCancel=0 ";
        strQ += "        WHERE lt.IsCancel = 0 ";

        if (TypeofTnx.ToUpper() == "'ALL'")
            strQ += "        AND lt.TypeOfTnx IN('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        else
            strQ += "        AND lt.TypeOfTnx IN(" + TypeofTnx + ")  ";
        
        if (TypeofTnx.ToUpper() != "'ALL'")
            strQ += "        AND ltd.ConfigID IN(" + ConfigIDs + ")  ";

        if (CompType == "1")
        {
            strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateTo + "'  ";
        }
        else if (CompType == "2")
        {
            strQ += "               AND DATE(lt.Date)>='" + DateFromC + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateToC + "' ";
        }

        strQ += "    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        strQ += "    WHERE pmh.PanelID=" + PanelID + " ";
        strQ += ")t1 INNER JOIN patient_master pm ON t1.PatientID= pm.PatientID ";

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetails.DataSource = dt;
            grdDetails.DataBind();

            ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            ((Label)grdDetails.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }

    }

    private DataTable MergeExtraRows(DataTable dtMain, string GroupingID,string ViewType,string Days1,string Days2)
    {
        dtMain.Columns.Add("QtyGrowth");
        dtMain.Columns.Add("GrossGrowth");
        dtMain.Columns.Add("DiscGrowth");
        dtMain.Columns.Add("NetGrowth");
        dtMain.Columns.Add("CollectedGrowth");

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

                drNewRow["Qty"] = "0";
                drNewRow["Gross"] = "0";
                drNewRow["Disc"] = "0";
                drNewRow["Net"] = "0";
                drNewRow["Collected"] = "0";

                //Defining Growth for Color Coding
                dtMain.Rows[i]["Growth"] = "Y";
                drNewRow["Growth"] = "N";

                drNewRow["QtyGrowth"] = "N";
                drNewRow["GrossGrowth"] = "N";
                drNewRow["DiscGrowth"] = "N";
                drNewRow["NetGrowth"] = "N";
                drNewRow["CollectedGrowth"] = "N";

                dtMain.Rows[i]["QtyGrowth"] = "Y";
                dtMain.Rows[i]["GrossGrowth"] = "Y";
                dtMain.Rows[i]["DiscGrowth"] = "Y";
                dtMain.Rows[i]["NetGrowth"] = "Y";
                dtMain.Rows[i]["CollectedGrowth"] = "Y";

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
                drNewRow["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Collected"]), 2));
                drNewRow["CompType"] = Util.GetString("3");

                if (dtMain.Rows[i+1]["CompType"].ToString() == "2")
                {
                    if (dtMain.Rows[i+1]["QtyGrowth"].ToString() == "N")
                        drNewRow["Qty"] = Util.GetString(Util.GetDecimal(drNewRow["Qty"]) * (-1));

                    if (dtMain.Rows[i+1]["GrossGrowth"].ToString() == "N")
                        drNewRow["Gross"] = Util.GetString(Util.GetDecimal(drNewRow["Gross"]) * (-1));

                    if (dtMain.Rows[i+1]["DiscGrowth"].ToString() == "N")
                        drNewRow["Disc"] = Util.GetString(Util.GetDecimal(drNewRow["Disc"]) * (-1));

                    if (dtMain.Rows[i+1]["NetGrowth"].ToString() == "N")
                        drNewRow["Net"] = Util.GetString(Util.GetDecimal(drNewRow["Net"]) * (-1));

                    if (dtMain.Rows[i+1]["CollectedGrowth"].ToString() == "N")
                        drNewRow["Collected"] = Util.GetString(Util.GetDecimal(drNewRow["Collected"]) * (-1));
                }

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

                if (Util.GetDecimal(drNewRow["Collected"]) >= 0)
                    drNewRow["CollectedGrowth"] = "Y";
                else
                    drNewRow["CollectedGrowth"] = "N";

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
                    drNewRow["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Collected"]) - Util.GetDecimal(drFound[1]["Collected"]), 2));
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
                    drNewRow["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Collected"]) - Util.GetDecimal(drFound[0]["Collected"]), 2));
                    drNewRow["CompType"] = Util.GetString("3");
                }

                drNewRow["Name"] = "Difference Total :";

                if (Util.GetDecimal(drNewRow["Qty"])>= 0)
                    drNewRow["QtyGrowth"] = "Y";
                else
                    drNewRow["QtyGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Gross"])>= 0)
                    drNewRow["GrossGrowth"] = "Y";
                else
                    drNewRow["GrossGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Disc"])>= 0)
                    drNewRow["DiscGrowth"] = "Y";
                else
                    drNewRow["DiscGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Net"])>= 0)
                    drNewRow["NetGrowth"] = "Y";
                else
                    drNewRow["NetGrowth"] = "N";

                if (Util.GetDecimal(drNewRow["Collected"])>= 0)
                    drNewRow["CollectedGrowth"] = "Y";
                else
                    drNewRow["CollectedGrowth"] = "N";

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
        dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Collected)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=2"))));
        dr1["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Gross)", "CompType=2"))));
        dr1["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Disc)", "CompType=2"))));
        dr1["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Net)", "CompType=2"))));
        dr1["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Collected)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "Total Difference";
        dr2["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Qty"]) - Util.GetDecimal(dr["Qty"])));
        dr2["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Gross"]) - Util.GetDecimal(dr["Gross"])));
        dr2["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Disc"]) - Util.GetDecimal(dr["Disc"])));
        dr2["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Net"]) - Util.GetDecimal(dr["Net"])));
        dr2["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dr1["Collected"]) - Util.GetDecimal(dr["Collected"])));
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

        if (Util.GetDecimal(dr2["Collected"]) >= 0)
            dr2["CollectedGrowth"] = "Y";
        else
            dr2["CollectedGrowth"] = "N";



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
                drNewRow["Collected"] = "0";

                //Putting Avg per Day for each field

                dtMain.Rows[i]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Qty"]) / Util.GetDecimal(Days2),2));
                dtMain.Rows[i]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Gross"]) / Util.GetDecimal(Days2),2));
                dtMain.Rows[i]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Disc"]) / Util.GetDecimal(Days2),2));
                dtMain.Rows[i]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Net"]) / Util.GetDecimal(Days2),2));
                dtMain.Rows[i]["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Rows[i]["Collected"]) / Util.GetDecimal(Days2),2));


                //Defining Growth for Color Coding
                dtMain.Rows[i]["Growth"] = "Y";
                drNewRow["Growth"] = "N";

                drNewRow["QtyGrowth"] = "N";
                drNewRow["GrossGrowth"] = "N";
                drNewRow["DiscGrowth"] = "N";
                drNewRow["NetGrowth"] = "N";
                drNewRow["CollectedGrowth"] = "N";

                dtMain.Rows[i]["QtyGrowth"] = "Y";
                dtMain.Rows[i]["GrossGrowth"] = "Y";
                dtMain.Rows[i]["DiscGrowth"] = "Y";
                dtMain.Rows[i]["NetGrowth"] = "Y";
                dtMain.Rows[i]["CollectedGrowth"] = "Y";

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
                    drNewRow["Collected"] = "100";
                }
                else
                {
                    drNewRow["Qty"] = "0";
                    drNewRow["Gross"] = "0";
                    drNewRow["Disc"] = "0";
                    drNewRow["Net"] = "0";
                    drNewRow["Collected"] = "0";
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

                    if (dtMain.Rows[i]["CollectedGrowth"].ToString() == "N")
                        drNewRow["Collected"] = Util.GetString(Util.GetDecimal(drNewRow["Collected"]) * (-1));
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
                    drFound[0]["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Collected"]) / Util.GetDecimal(Days2)));

                    //Avg Per Day of 1st Period
                    drFound[1]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) / Util.GetDecimal(Days1)));
                    drFound[1]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Gross"]) / Util.GetDecimal(Days1)));
                    drFound[1]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Disc"]) / Util.GetDecimal(Days1)));
                    drFound[1]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Net"]) / Util.GetDecimal(Days1)));
                    drFound[1]["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Collected"]) / Util.GetDecimal(Days1)));

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
                        drNewRow["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Qty"]) - Util.GetDecimal(drFound[1]["Qty"]))/Util.GetDecimal(drFound[1]["Qty"])) * 100, 2));
                    else
                        drNewRow["Qty"] = "100";
                    if (Util.GetDecimal(drFound[1]["Gross"]) > 0)
                        drNewRow["Gross"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Gross"]) - Util.GetDecimal(drFound[1]["Gross"]))/Util.GetDecimal(drFound[1]["Gross"])) * 100, 2));
                    else
                        drNewRow["Gross"] = "100";
                    if (Util.GetDecimal(drFound[1]["Disc"]) > 0)
                        drNewRow["Disc"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Disc"]) - Util.GetDecimal(drFound[1]["Disc"]))/Util.GetDecimal(drFound[1]["Disc"])) * 100, 2));
                    else
                        drNewRow["Disc"] = "100";
                    if (Util.GetDecimal(drFound[1]["Net"]) > 0)
                        drNewRow["Net"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Net"]) - Util.GetDecimal(drFound[1]["Net"]))/Util.GetDecimal(drFound[1]["Net"])) * 100, 2));
                    else
                        drNewRow["Net"] = "100";
                    if (Util.GetDecimal(drFound[1]["Collected"]) > 0)
                        drNewRow["Collected"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[0]["Collected"]) - Util.GetDecimal(drFound[1]["Collected"]))/Util.GetDecimal(drFound[1]["Collected"])) * 100, 2));
                    else
                        drNewRow["Collected"] = "100";

                    drNewRow["CompType"] = Util.GetString("3");
                }
                else
                {
                    //Avg Per Day of 2nd Period
                    drFound[0]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Qty"]) / Util.GetDecimal(Days1),2));
                    drFound[0]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Gross"]) / Util.GetDecimal(Days1),2));
                    drFound[0]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Disc"]) / Util.GetDecimal(Days1),2));
                    drFound[0]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Net"]) / Util.GetDecimal(Days1),2));
                    drFound[0]["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[0]["Collected"]) / Util.GetDecimal(Days1),2));

                    //Avg Per Day of 1st Period
                    drFound[1]["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Qty"]) / Util.GetDecimal(Days2),2));
                    drFound[1]["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Gross"]) / Util.GetDecimal(Days2),2));
                    drFound[1]["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Disc"]) / Util.GetDecimal(Days2),2));
                    drFound[1]["Net"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Net"]) / Util.GetDecimal(Days2),2));
                    drFound[1]["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(drFound[1]["Collected"]) / Util.GetDecimal(Days2),2));


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

                    if (Util.GetDecimal(drFound[0]["Collected"]) > 0)
                        drNewRow["Collected"] = Util.GetString(Math.Round(((Util.GetDecimal(drFound[1]["Collected"]) - Util.GetDecimal(drFound[0]["Collected"]))/Util.GetDecimal(drFound[0]["Collected"])) * 100, 2));
                    else
                        drNewRow["Collected"] = "100";

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

                if (Util.GetDecimal(drNewRow["Collected"]) >= 0)
                    drNewRow["CollectedGrowth"] = "Y";
                else
                    drNewRow["CollectedGrowth"] = "N";

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
        dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Collected)", "CompType=1"))));
        dr["CompType"] = Util.GetString("1");
        dtMain.Rows.InsertAt(dr, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr1 = dtMain.NewRow();
        dr1[0] = "Total of 2nd Period";
        dr1["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Qty)", "CompType=2"))));
        dr1["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Gross)", "CompType=2"))));
        dr1["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Disc)", "CompType=2"))));
        dr1["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Net)", "CompType=2"))));
        dr1["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dtMain.Compute("sum(Collected)", "CompType=2"))));
        dr1["CompType"] = Util.GetString("2");
        dtMain.Rows.InsertAt(dr1, dtMain.Rows.Count + 1);
        dtMain.AcceptChanges();

        DataRow dr2 = dtMain.NewRow();
        dr2[0] = "OverAll Growth/Decline in Percentage";
                
        if (Util.GetDecimal(dr["Qty"]) > 0)
            dr2["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Qty"]) - Util.GetDecimal(dr["Qty"]))/Util.GetDecimal(dr["Qty"])) * 100, 2));
        else
            dr2["Qty"] = "100";

        if (Util.GetDecimal(dr["Gross"]) > 0)
            dr2["Gross"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Gross"]) - Util.GetDecimal(dr["Gross"]))/Util.GetDecimal(dr["Gross"])) * 100, 2));
        else
            dr2["Gross"] = "100";

        if (Util.GetDecimal(dr["Disc"]) > 0)
            dr2["Disc"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Disc"]) - Util.GetDecimal(dr["Disc"]))/Util.GetDecimal(dr["Disc"])) * 100, 2));
        else
            dr2["Disc"] = "100";

        if (Util.GetDecimal(dr["Net"]) > 0)
            dr2["Net"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Net"]) - Util.GetDecimal(dr["Net"]))/Util.GetDecimal(dr["Net"])) * 100, 2));
        else
            dr2["Net"] = "100";

        if (Util.GetDecimal(dr["Collected"]) > 0)
            dr2["Collected"] = Util.GetString(Math.Round(((Util.GetDecimal(dr1["Collected"]) - Util.GetDecimal(dr["Collected"]))/Util.GetDecimal(dr["Collected"])) * 100, 2));
        else
            dr2["Collected"] = "100";
        
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

        if (Util.GetDecimal(dr2["Collected"]) >= 0)
            dr2["CollectedGrowth"] = "Y";
        else
            dr2["CollectedGrowth"] = "N";

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
                e.Row.BackColor =System.Drawing.Color.White;

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

                if (((Label)e.Row.FindControl("lblDocCollectedGrowth")).Text == "Y")
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

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

                if (((Label)e.Row.FindControl("lblSpecCollectedGrowth")).Text == "Y")
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

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

                if (((Label)e.Row.FindControl("lblSubCatCollectedGrowth")).Text == "Y")
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

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

                if (((Label)e.Row.FindControl("lblPanelCollectedGrowth")).Text == "Y")
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#00C000");
                else
                    e.Row.Cells[6].ForeColor = System.Drawing.ColorTranslator.FromHtml("#F12C44");

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
                LoadDocDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), DocID, CompType, ViewState["ConfigIDs"].ToString());
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
                LoadItemDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), ItemID, CompType, ViewState["ConfigIDs"].ToString());
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
                LoadSubCatDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), SubCategoryID, CompType, ViewState["ConfigIDs"].ToString());
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
                LoadPanelDetailCompData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateFromC"].ToString(), ViewState["DateToC"].ToString(), ViewState["TypeofTnx"].ToString(), PanelID, CompType, ViewState["ConfigIDs"].ToString());
                mpSelect.Show();
            }
        }
    }

    protected void grdDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string LedgerTransactionNo = ((Label)e.Row.FindControl("lblLedgerTransactionNo")).Text;
            string strQ = "Select Quantity,Rate,Amount,((Rate*Quantity)-Amount)Disc,ItemName from f_LedgerTnxDetail where LedgertransactionNo='" + LedgerTransactionNo + "' ";
            DataTable dt = StockReports.GetDataTable(strQ);
            string strDetail = MakeDetail(dt, LedgerTransactionNo);
            Response.Write(strDetail);
            //HtmlGenericControl HgcDiv = new HtmlGenericControl();
            //HgcDiv = (HtmlGenericControl)e.Row.FindControl("dvDetail");
            //HgcDiv.InnerText = strDetail;

            //e.Row.Attributes.Add("onmouseover", "javascript:showTip(event," + HgcDiv + ");");
            e.Row.CssClass = "example3tooltip";
            e.Row.Attributes.Add("onmouseover", "showDiv('dvDetail_" + LedgerTransactionNo + "');");

        }

    }

    private string MakeDetail(DataTable dt, string LedgerTransactionNo)
    {
        string Detail = "";
        if (dt != null && dt.Rows.Count > 0)
        {
            Detail = "<Div id='dvDetail_" + LedgerTransactionNo + "' style='display:none; z-index:1000;'>";
            Detail += "<table border='0' cellpadding='1' cellspacing='0' style='width: 500px'>";
            Detail += "    <tr>";
            Detail += "        <td style='width: 5%' class='ItDoseLblSpBl'>";
            Detail += "            #</td>";
            Detail += "        <td style='width: 50%' class='ItDoseLblSpBl'>";
            Detail += "            ItemName</td>";
            Detail += "        <td align='center' style='width: 6%' class='ItDoseLblSpBl'>";
            Detail += "            Qty</td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>";
            Detail += "            Rate</td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>";
            Detail += "            Disc</td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>";
            Detail += "            Net</td>";
            Detail += "    </tr>";


            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Detail += "    <tr>";
                Detail += "        <td style='width: 5%' class='ItDoseLabelSp'>" + Util.GetString(i + 1);
                Detail += "        </td>";
                Detail += "        <td style='width: 50%' class='ItDoseLabelSp'>" + dt.Rows[i]["ItemName"].ToString();
                Detail += "        </td>";
                Detail += "        <td align='center' style='width: 6%' class='ItDoseLabelSp'>" + dt.Rows[i]["Quantity"].ToString();
                Detail += "        </td>";
                Detail += "        <td align='right' style='width: 13%' class='ItDoseLabelSp'>" + dt.Rows[i]["Rate"].ToString();
                Detail += "        </td>";
                Detail += "        <td align='right' style='width: 13%' class='ItDoseLabelSp'>" + Util.GetString(Math.Round(Util.GetDecimal(dt.Rows[i]["Disc"]), 2));
                Detail += "        </td>";
                Detail += "        <td align='right' style='width: 13%' class='ItDoseLabelSp'>" + Util.GetString(Math.Round(Util.GetDecimal(dt.Rows[i]["Amount"]), 2));
                Detail += "        </td>";
                Detail += "    </tr>";
            }

            Detail += "    <tr>";
            Detail += "        <td style='width: 5%' class='ItDoseLblSpBl'>";
            Detail += "        </td>";
            Detail += "        <td style='width: 50%' class='ItDoseLblSpBl'><strong>Total :</strong>";
            Detail += "        </td>";
            Detail += "        <td align='center' style='width: 6%' class='ItDoseLblSpBl'>";
            Detail += "        </td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>";
            Detail += "        </td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>" + Util.GetString(dt.Compute("sum(Disc)", ""));
            Detail += "        </td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>" + Util.GetString(dt.Compute("sum(Amount)", "")); ;
            Detail += "        </td>";
            Detail += "    </tr>";
            Detail += "</table>";
            Detail += "</Div>";
        }

        return Detail;
    }

}
