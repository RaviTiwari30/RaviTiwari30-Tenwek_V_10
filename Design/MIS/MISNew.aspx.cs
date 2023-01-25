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

public partial class Design_MIS_MISNew : System.Web.UI.Page
{    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text =DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            TabContainer1.ActiveTabIndex = 0;            
        }
    }

    protected void TabContainer1_ActiveTabChanged(object sender, EventArgs e)
    {
        string url = "";
        if (TabContainer1.ActiveTabIndex == 0)
        {
            lblOverview.Text = "SUMMARISED OVERVIEW";
            ViewState["DateFrom"] = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
            ViewState["DateTo"] = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
            ViewState["DateType"] = rbtDateType.SelectedValue;
            
            //CreateOPDGrid();
            //CreateIPDStatisticsGrid();
            //CreateIPDServicesGrid();
            //CreateRevenueGeneratedGrid();
        }
        else if (TabContainer1.ActiveTabIndex == 1)
        {
            if (ViewState["TransactionType"] == null)
                return;

            switch (ViewState["TransactionType"].ToString())
            {
                case "OPD-Services":
                    url = "NewMIS/MISOPD.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;

                case "IPD-Statistics":
                    if (ViewState["TypeOfTnx"].ToString() == "ADMISSION")
                        url = "NewMIS/MISIPDAdmission.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "DISCHARGE")
                        url = "NewMIS/MISIPDDischarge.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "BILL-GENERATED")
                        url = "NewMIS/MISIPDBillGenerated.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();

                    break;

                case "IPD-Services":
                    if (ViewState["TypeOfTnx"].ToString() == "IPD-INVESTIGATION")
                        url = "NewMIS/MISIPDInvestigation.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "IPD-CONSULTATION")
                        url = "NewMIS/MISIPDConsultation.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "IPD-PACKAGE")
                        url = "NewMIS/MISIPDPackage.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else
                        url = "NewMIS/MISIPDOtherServices.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();

                    break;                

                default:
                    break;
            }
            ((HtmlContainerControl)TabContainer1.Tabs[1].FindControl("frmDetail")).Attributes.Add("src", url);
        }
        else if (TabContainer1.ActiveTabIndex == 2)
        {
            switch (ViewState["TransactionType"].ToString())
            {
                case "OPD-Services":
                    url = "NewMIS/MISOPDAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;

                case "IPD-Statistics":
                    if (ViewState["TypeOfTnx"].ToString() == "ADMISSION")
                        url = "NewMIS/MISIPDInvestigationAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "DISCHARGE")
                        url = "NewMIS/MISIPDDischargeAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "BILL-GENERATED")
                        url = "NewMIS/MISIPDBillGeneratedAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();

                    break;
                case "IPD-Services":
                    if (ViewState["TypeOfTnx"].ToString() == "IPD-INVESTIGATION")
                        url = "NewMIS/MISIPDInvestigationAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "IPD-CONSULTATION")
                        url = "NewMIS/MISIPDConsultationAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else if (ViewState["TypeOfTnx"].ToString() == "IPD-PACKAGE")
                        url = "NewMIS/MISIPDPackageAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    else
                        url = "NewMIS/MISIPDOtherServicesAnalysis.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();

                    break;        

                default:
                    
                    break;
            }
            
            ((HtmlContainerControl)TabContainer1.Tabs[2].FindControl("frmAnalysis")).Attributes.Add("src", url);
        }
    }

    private void CreateOPDGrid()
    {        
        DataTable dt = LoadAllOPD(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateType"].ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblOPD.InnerText = "OPD Services";
            lblOverAllCASH.InnerText = "OverAll CASH";
            grdOPDSummary.DataSource = dt;
            grdOPDSummary.DataBind();


            ((Label)grdOPDSummary.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
          
            ((Label)grdOPDSummary.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
                       ((Label)grdOPDSummary.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            ((Label)grdOPDSummary.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
        }
        else
        {
            lblOPD.InnerText = "";
            lblOverAllCASH.InnerText = "";
            grdOPDSummary.DataSource = null;
            grdOPDSummary.DataBind();
        }
    }

    private void CreateIPDStatisticsGrid()
    {
        DataTable dt = LoadAllIPD(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateType"].ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblIPDStatistics.InnerText = "IPD Statistics";
            grdIPDSummary.DataSource = dt;
            grdIPDSummary.DataBind();
           
        }
        else
        {
            lblIPDStatistics.InnerText = "";
            grdIPDSummary.DataSource = null;
            grdIPDSummary.DataBind();
        }
    }    

    private void CreateIPDServicesGrid()
    {        
        DataTable dt = LoadAllIPDServices(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateType"].ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblOverAllRevenue.InnerText = "OverAll Revenue";
            lblIPDServices.InnerText = "IPD Services";
            grdIPDServices.DataSource = dt;
            grdIPDServices.DataBind();

            ((Label)grdIPDServices.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            ((Label)grdIPDServices.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            ((Label)grdIPDServices.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));            
        }
        else
        {
            lblOverAllRevenue.InnerText = "";
            lblIPDServices.InnerText = "";
            grdIPDServices.DataSource = null;
            grdIPDServices.DataBind();
        }


    }

    private void CreateRevenueGeneratedGrid()
    {
        DataTable dt = LoadRevenueGenerated(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["DateType"].ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdRevenue.DataSource = dt;
            grdRevenue.DataBind();
            
        }
        else
        {
            grdRevenue.DataSource = null;
            grdRevenue.DataBind();
        }
    }
    private DataTable LoadAllOPD(string DateFrom,string DateTo,string DateType)
    {
        string strQ = "";
        strQ += "SELECT UCASE(t1.TypeOfTnx)TypeOfTnx,ROUND(SUM(Qty),2)Qty,";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,"; 
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,";
        strQ += "'" + DateFrom + "' DateFrom,'" + DateTo + "' DateTo,'" + DateType + "' DateType FROM (";
        strQ += "        SELECT Quantity Qty,Gross,IFNULL(Disc,0)Disc,Net,"; 
        strQ += "        IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,";
        strQ += "        (CASE WHEN ConfigID in (4,5) THEN 'OPD-CONSULTATION'";
        strQ += "        WHEN ConfigID=3 AND TypeOfTnx='OPD-BILLING' THEN 'OPD-INVESTIGATIONS'";
        strQ += "        WHEN ConfigID=3 AND TypeOfTnx='OPD-LAB' THEN 'OPD-INVESTIGATIONS'";
        strQ += "        WHEN ConfigID IN (25,7) AND TypeOfTnx='OPD-BILLING' THEN 'OPD-MINOR PROCEDURES'";
        strQ += "        WHEN ConfigID IN (25,7) AND TypeOfTnx='OPD-PROCEDURE' THEN 'OPD-MINOR PROCEDURES'";
        strQ += "        WHEN ConfigID IN (6,20,11) AND TypeOfTnx='OPD-BILLING' THEN 'OPD-OTHER MISC'";
        strQ += "        WHEN ConfigID IN (6,20) AND TypeOfTnx='OPD-OTHERS' THEN 'OPD-OTHER MISC'";
        strQ += "        ELSE TypeOfTnx END)TypeOfTnx,LedgerTransactionNo FROM ("; 
        strQ += "                SELECT ltd.TransactionID,ltd.Quantity,LT.LedgerTransactionNo,";
        strQ += "                (Rate*Quantity)Gross, ";
        strQ += "                ROUND(ltd.DiscAmt,2)Disc,((ltd.Rate*ltd.Quantity)-ROUND(ltd.DiscAmt,2)) Net,ltd.ItemID,IFNULL((SELECT sum(AmountPaid) "; 
        strQ += "                FROM f_reciept WHERE AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "                AND IsCancel=0 group by AsainstLedgerTnxNo ),0)Collected,";
        // change amountpaid and group by added
        strQ += "                (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "                WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,";
        strQ += "                CF.ConfigID,lt.TypeOfTnx ";
        strQ += "                FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "                INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "                WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-APPOINTMENT',";
        strQ += "                'OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')";
        strQ += "                AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "                AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "        )t ";
        strQ += ")t1 GROUP BY TypeOfTnx order by TypeOfTnx";
        DataTable dt = StockReports.GetDataTable(strQ);

        return dt;
    }

    private DataTable LoadAllIPD(string DateFrom,string DateTo,string DateType)
    { 
        string strQ = "";
        
        strQ += "SELECT TypeofTnx,Qty, ";
        strQ += "'" + DateFrom + "' DateFrom,'" + DateTo + "' DateTo,'" + DateType + "' DateType FROM ( ";
	    strQ += "    SELECT TypeOfTnx,COUNT(t.TransactionID)Qty FROM ( ";
        strQ += "        SELECT 'ADMISSION' TypeOfTnx,ich.TransactionID FROM patient_medical_history ich ";      
		strQ += "        WHERE ich.status <>'CANCEL' ";  
		strQ += "        AND DATE(DateOfAdmit)>='" + DateFrom + "' ";  
		strQ += "        AND  DATE(DateOfAdmit)<='" + DateTo + "' "; 
	    strQ += "    )t GROUP BY TypeOfTnx ";
        strQ +=" UNION ALL ";
        strQ += "   SELECT 'Current Admitted' `Status`,COUNT(*)`Count` FROM patient_medical_history ich ";
       strQ += "  WHERE ich.Status='IN' ";
	    strQ += "    UNION ALL ";
	    strQ += "    SELECT TypeOfTnx,COUNT(t.TransactionID)Qty FROM ( ";
        strQ += "        SELECT 'DISCHARGE' TypeOfTnx,ich.TransactionID FROM patient_medical_history ich ";
        strQ += "        WHERE ich.status <>'CANCEL' and Status='OUT' ";  
		strQ += "        AND DATE(DateOfDischarge)>='" + DateFrom + "' ";
        strQ += "        AND  DATE(DateOfDischarge)<='" + DateTo + "' "; 
	    strQ += "    )t GROUP BY TypeOfTnx  ";
	    strQ += "    UNION ALL ";
	    strQ += "    SELECT TypeOfTnx,COUNT(TransactionID)Qty FROM ( ";
		strQ += "        SELECT 'BILL-GENERATED' TypeOfTnx,TransactionID FROM f_ledgertransaction "; 
		strQ += "        WHERE IFNULL(Billno,'')<>'' AND BillType='IPD' "; 
		strQ += "        AND DATE(BillDate)>='" + DateFrom + "' "; 
		strQ += "        AND  DATE(BillDate)<='" + DateTo + "' "; 
		strQ += "        GROUP BY TransactionID "; 
	    strQ += "    )t GROUP BY TypeOfTnx ";
        strQ += ")t ORDER BY TypeOfTnx";
        DataTable dt = StockReports.GetDataTable(strQ);
        return dt;

    }

    private DataTable LoadAllIPDServices(string DateFrom,string DateTo,string DateType)
    { 
        string strQ = "";

        strQ += "SELECT UCASE(TypeOfTnx)TypeOfTnx,ROUND(SUM(Gross))Gross, ";        
        strQ += "ROUND(SUM(Disc))Disc,ROUND(SUM(Net))Net,ROUND(SUM(Qty))Qty,";
        strQ += "'" + DateFrom + "' DateFrom,'" + DateTo + "' DateTo,'" + DateType + "' DateType  FROM ( ";
		strQ += "            SELECT (CASE WHEN cf.ConfigID=3 THEN 'IPD-INVESTIGATION' ";  
		strQ += "            WHEN cf.ConfigID=14 THEN 'IPD-PACKAGE' "; 
		strQ += "            WHEN cf.ConfigID=1 THEN 'IPD-CONSULTATION' "; 
		strQ += "            ELSE IF(IFNULL(sc.DisplayName,''),sc.Name,sc.DisplayName) ";
		strQ += "            END)TypeOfTnx,(ltd.Rate*ltd.Quantity)Gross, ";
        //strQ += "           ROUND(((ltd.rate*ltd.quantity)-(ltd.Amount)),2)Disc,ltd.Amount Net,ltd.Quantity Qty ";
        strQ += "            ROUND(ltd.DiscAmt,2)Disc,((ltd.Rate*ltd.Quantity)-ROUND(ltd.DiscAmt,2)) Net,ltd.Quantity Qty ";
        strQ += "            FROM patient_medical_history adj INNER JOIN f_ledgertnxdetail ltd ON ";
        strQ += "            adj.TransactionID = ltd.TransactionID "; 
		strQ += "            INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID "; 
		strQ += "            INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "            WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  AND ltd.TYPE = 'I'  AND ltd.configID<>22 ";
        
        if (DateType == "1")
        {
            strQ += "        AND DATE(adj.BillDate)>='" + DateFrom + "' AND DATE(adj.BillDate)<='" + DateTo + "' ";
            strQ += "        AND ifnull(adj.BillNo,'')<>'' ";
        }
        else
            strQ += "        AND DATE(ltd.EntryDate)>='" + DateFrom + "' AND DATE(ltd.EntryDate)<='" + DateTo + "' ";


        strQ += "            union All ";

        strQ += "            SELECT (CASE WHEN cf.ConfigID=3 THEN 'IPD-INVESTIGATION' ";
        strQ += "            WHEN cf.ConfigID=14 THEN 'IPD-PACKAGE' ";
        strQ += "            WHEN cf.ConfigID=1 THEN 'IPD-CONSULTATION' ";
        strQ += "            ELSE IF(IFNULL(sc.DisplayName,''),sc.Name,sc.DisplayName) ";
        strQ += "            END)TypeOfTnx,sum(ltd.Rate*ltd.Quantity)Gross, ";
        //strQ += "            ROUND(SUM(IF(ltd.DiscountPercentage>0,((Rate*Quantity)-(Amount)),0)),2)Disc,sum(ltd.Amount) Net,1 as Qty ";
        strQ += "            ROUND(SUM(ltd.DiscAmt),2)Disc,SUM(((ltd.Rate*ltd.Quantity)-ROUND(ltd.DiscAmt,2))) Net,1 as Qty ";
        strQ += "            FROM patient_medical_history adj INNER JOIN f_ledgertnxdetail ltd ON ";
        strQ += "            adj.TransactionID = ltd.TransactionID ";
        strQ += "            INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "            INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "            WHERE ltd.IsVerified=1 AND ltd.IsPackage=0 AND ltd.TYPE = 'I'  AND ltd.configID=22 ";

        if (DateType == "1")
       {
            strQ += "        AND DATE(adj.BillDate)>='" + DateFrom + "' AND DATE(adj.BillDate)<='" + DateTo + "' ";
            strQ += "        AND ifnull(adj.BillNo,'')<>'' ";
        }
        else
            strQ += "        AND DATE(ltd.EntryDate)>='" + DateFrom + "' AND DATE(ltd.EntryDate)<='" + DateTo + "' ";

        strQ = strQ + "      GROUP BY ltd.LedgerTransactionNo";







        strQ += ")t GROUP BY TypeOfTnx ORDER BY TypeOfTnx ";

        DataTable dt = StockReports.GetDataTable(strQ);
        return dt;
    }

    private DataTable LoadRevenueGenerated(string DateFrom, string DateTo, string DateType)
    {
        string strQ = "";
       
        ////////strQ += "Select TypeOfTnx,Qty,Gross,Disc,Net from (";
        ////////strQ += "       SELECT UCASE(t1.TypeOfTnx)TypeOfTnx,ROUND(SUM(Qty),2)Qty,";
        ////////strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        ////////strQ += "       ROUND(SUM(Net))Net FROM (";
        ////////strQ += "               SELECT Quantity Qty,Gross,Disc,Net,";
        ////////strQ += "               IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,";
        ////////strQ += "               'OPD' TypeOfTnx,LedgerTransactionNo FROM (";
        ////////strQ += "                       SELECT ltd.TransactionID,ltd.Quantity,LT.LedgerTransactionNo,";
        ////////strQ += "                       (Rate*Quantity)Gross,TotalDiscAmt Disc,";
        ////////strQ += "                       NetItemAmt Net,ltd.ItemID,IFNULL((SELECT sum(AmountPaid) ";
        ////////strQ += "                       FROM f_reciept WHERE AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        ////////strQ += "                       AND IsCancel=0  group by AsainstLedgerTnxNo),0)Collected,";
        //////////change 18-12-13 sum(amountpaid) and group by added
        ////////strQ += "                       (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        ////////strQ += "                       WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,";
        ////////strQ += "                       CF.ConfigID,lt.TypeOfTnx ";
        ////////strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        ////////strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        ////////strQ += "                       INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        ////////strQ += "                       INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        ////////strQ += "                       WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-APPOINTMENT',";
        ////////strQ += "                       'OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','CASUALTY-BILLING')";
        ////////strQ += "                       AND DATE(lt.Date)>='" + DateFrom + "' ";
        ////////strQ += "                       AND DATE(lt.Date)<='" + DateTo + "' ";
        ////////strQ += "               )t ";
        ////////strQ += "       )t1 GROUP BY TypeOfTnx";
        ////////strQ += "       UNION ALL ";
        ////////strQ += "       SELECT 'IPD' TypeOfTnx,ROUND(SUM(Qty),2)Qty,ROUND(SUM(Gross))Gross,";
        ////////strQ += "       ROUND(SUM(Disc)+SUM(DiscountOnBill))Disc,";
        ////////strQ += "       ROUND(SUM(Net)-SUM(DiscountOnBill))Net FROM (";
        ////////strQ += "           SELECT SUM(Qty)Qty,SUM(Gross)Gross,SUM(Disc)Disc,";
        ////////strQ += "           SUM(Net)Net,DiscountOnBill FROM (";
        ////////strQ += "               SELECT ltd.Quantity Qty,(Rate*Quantity)Gross,";
        ////////strQ += "               IF(ltd.DiscountPercentage>0,((Rate*Quantity)-(Amount)),0)Disc,(Amount)Net,";
        ////////strQ += "               IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.TransactionID FROM ";
        ////////strQ += "               f_ipdadjustment adj INNER JOIN f_ledgertnxdetail ltd ON ";
        ////////strQ += "               adj.TransactionID = ltd.TransactionID ";
        
        ////////if (DateType == "1")
        ////////{
        ////////    strQ += "           WHERE DATE(adj.BillDate)>='" + DateFrom + "' AND DATE(adj.BillDate)<='" + DateTo + "' ";
        ////////    strQ += "           AND ifnull(adj.BillNo,'')<>'' ";
        ////////}
        ////////else
        ////////    strQ += "           WHERE entryDATE >='" + DateFrom + " 00:00:00' AND entryDATE <='" + DateTo + " 00:00:00' ";

        ////////strQ += "               AND IsVerified=1 AND ltd.IsPackage=0 ";
        ////////strQ += "           )t GROUP BY t.TransactionID ";
        ////////strQ += "       )t";
        ////////strQ += ")t";
        

        //gaurav 16 sep 2013
        
        strQ += "Select TypeOfTnx,Qty,Gross,Disc,Net from (";
        strQ += "       SELECT UCASE(t1.TypeOfTnx)TypeOfTnx,ROUND(SUM(Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net FROM (";
        strQ += "               SELECT Quantity Qty,Gross,Disc,Net,";
        strQ += "               IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,";
        strQ += "               'OPD' TypeOfTnx,LedgerTransactionNo FROM (";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity,LT.LedgerTransactionNo,";
        strQ += "                       (Rate*Quantity)Gross,ROUND(ltd.DiscAmt,2)Disc,";
        strQ += "                       ((ltd.Rate*ltd.Quantity)-ROUND(ltd.DiscAmt,2))Net,ltd.ItemID,IFNULL((SELECT SUM(AmountPaid) ";
        strQ += "                       FROM f_reciept WHERE AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "                       AND IsCancel=0),0)Collected,";
        strQ += "                       (SELECT SUM(NetItemAmt)  FROM f_ledgertnxdetail ";
        strQ += "                       WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,";
        strQ += "                       CF.ConfigID,lt.TypeOfTnx ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "                       INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "                       WHERE lt.IsCancel = 0 AND lt.TypeOfTnx IN('OPD-APPOINTMENT',";
        strQ += "                       'OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')";
        strQ += "                       AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "                       AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               )t ";
        strQ += "       )t1 GROUP BY TypeOfTnx";
        strQ += "       UNION ALL ";
        strQ += "       SELECT 'IPD' TypeOfTnx,ROUND(SUM(Qty),2)Qty,ROUND(SUM(Gross))Gross,";
        strQ += "       ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net FROM (";
        strQ += "           SELECT SUM(Qty)Qty,SUM(Gross)Gross,SUM(Disc)Disc,";
        strQ += "           SUM(Net)Net,DiscountOnBill FROM (";
        strQ += "               SELECT ltd.Quantity Qty,(Rate*Quantity)Gross,";
        strQ += "               (TotalDiscAmt)Disc,(NetItemAmt)Net,";
        strQ += "               IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.TransactionID FROM ";
        strQ += "               patient_medical_history adj INNER JOIN f_ledgertnxdetail ltd ON ";
        strQ += "               adj.TransactionID = ltd.TransactionID where  adj.TYPE='IPD' AND ";

        if (DateType == "1")
        {
            strQ += "            DATE(adj.BillDate)>='" + DateFrom + "' AND DATE(adj.BillDate)<='" + DateTo + "' ";
            strQ += "           AND ifnull(adj.BillNo,'')<>'' ";
        }
        else
            strQ += "            ltd.entryDATE >='" + DateFrom + " 00:00:00' AND ltd.entryDATE <='" + DateTo + " 00:00:00' ";

        strQ += "               AND IsVerified=1 AND IsPackage=0 ";
        strQ += "           )t GROUP BY t.TransactionID ";
        strQ += "       )t";
        strQ += ")t";
        
        //

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr["TypeofTnx"] = "Total Revenue :";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", "")),2));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", "")), 2));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", "")), 2));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", "")), 2));
            dt.Rows.Add(dr);

            Decimal TotalQty = Util.GetDecimal(dr["Qty"]);
            Decimal TotalGross = Util.GetDecimal(dr["Gross"]);
            Decimal TotalDisc = Util.GetDecimal(dr["Disc"]);
            Decimal TotalNet = Util.GetDecimal(dr["Net"]);

            //Creting New Row with copy of above rows for calculating in percentage
            for(int i=0;i<3;i++)
            {
                DataRow NewRow = dt.NewRow();
                NewRow.ItemArray = dt.Rows[i].ItemArray;
                NewRow["TypeOfTnx"] = dt.Rows[i]["TypeOfTnx"].ToString() + " (in %)";
                NewRow["Qty"] = Util.GetString(Math.Round(((Util.GetDecimal(dt.Rows[i]["Qty"]) / TotalQty) * 100),2));
                NewRow["Gross"] = Util.GetString(Math.Round(((Util.GetDecimal(dt.Rows[i]["Gross"]) / TotalGross) * 100),2));
                if (TotalDisc == 0)
                {
                    NewRow["Disc"] = 0;
                }
                else
                {
                    NewRow["Disc"] = Util.GetString(Math.Round(((Util.GetDecimal(dt.Rows[i]["Disc"]) / TotalDisc) * 100), 2));
                }
                NewRow["Net"] = Util.GetString(Math.Round(((Util.GetDecimal(dt.Rows[i]["Net"]) / TotalNet) * 100), 2));
                dt.Rows.Add(NewRow);
            }




        }

        return dt;
    }


    protected void grdOPDSummary_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string Detail = Util.GetString(e.CommandArgument);
            string TypeOfTnx = Detail.Split('#')[0].ToString();
            string DateFrom = Detail.Split('#')[1].ToString();
            string DateTo = Detail.Split('#')[2].ToString();
            string DateType = Detail.Split('#')[3].ToString();

            ViewState["TypeOfTnx"] = TypeOfTnx;
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["DateType"] = DateType;

            string url = "NewMIS/MISOPD.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
            
            TabContainer1.ActiveTabIndex = 1;
            ((HtmlContainerControl)TabContainer1.Tabs[1].FindControl("frmDetail")).Attributes.Add("src", url);
            ViewState["TransactionType"] = "OPD-Services";
             
        }
    }

    protected void grdIPDSummary_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string url = "";
            string Detail = Util.GetString(e.CommandArgument);
            string TypeOfTnx = Detail.Split('#')[0].ToString();
            string DateFrom = Detail.Split('#')[1].ToString();
            string DateTo = Detail.Split('#')[2].ToString();
            string DateType = Detail.Split('#')[3].ToString();

            ViewState["TypeOfTnx"] = TypeOfTnx;
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["DateType"] = DateType;

            switch (TypeOfTnx)
            {
                case "ADMISSION":
                    url = "NewMIS/MISIPDAdmission.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;
                case "DISCHARGE":
                    url = "NewMIS/MISIPDDischarge.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;
                case "BILL-GENERATED":
                    url = "NewMIS/MISIPDBillGenerated.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;

                default:                    
                    break;
            }
            
            TabContainer1.ActiveTabIndex = 1;
            ((HtmlContainerControl)TabContainer1.Tabs[1].FindControl("frmDetail")).Attributes.Add("src", url);
            ViewState["TransactionType"] = "IPD-Statistics";

        }
    }
    protected void grdIPDServices_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string url = "";
            string Detail = Util.GetString(e.CommandArgument);
            string TypeOfTnx = Detail.Split('#')[0].ToString();
            string DateFrom = Detail.Split('#')[1].ToString();
            string DateTo = Detail.Split('#')[2].ToString();
            string DateType = Detail.Split('#')[3].ToString();

            ViewState["TypeOfTnx"] = TypeOfTnx;
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["DateType"] = DateType;

            switch (TypeOfTnx)
            {
                case "IPD-INVESTIGATION":
                    url = "NewMIS/MISIPDInvestigation.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;
                case "IPD-CONSULTATION":
                    url = "NewMIS/MISIPDConsultation.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;
                case "IPD-PACKAGE":
                    url = "NewMIS/MISIPDPackage.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;

                default:
                    url = "NewMIS/MISIPDOtherServices.aspx?SelectionType=" + ViewState["TypeOfTnx"].ToString() + "&DateFrom=" + ViewState["DateFrom"].ToString() + "&DateTo=" + ViewState["DateTo"].ToString() + "&DateType=" + ViewState["DateType"].ToString();
                    break;
            }

            TabContainer1.ActiveTabIndex = 1;
            ((HtmlContainerControl)TabContainer1.Tabs[1].FindControl("frmDetail")).Attributes.Add("src", url);
            ViewState["TransactionType"] = "IPD-Services";
        }
    }
   
    protected void btnView_Click(object sender, EventArgs e)
    {
        lblOverview.Text = "SUMMARISED OVERVIEW";
        ViewState["DateFrom"] = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
        ViewState["DateTo"] = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
        ViewState["DateType"] = rbtDateType.SelectedValue;

        CreateOPDGrid();
        CreateIPDStatisticsGrid();
        CreateIPDServicesGrid();
        CreateRevenueGeneratedGrid();
        BindTotalCash();
    }
    private void BindTotalCash()
    {
        DataTable dt = LoadTotalCash(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdCash.DataSource = dt;
            grdCash.DataBind();

        }
        else
        {
            grdCash.DataSource = null;
            grdCash.DataBind();
        }
    }
    private DataTable LoadTotalCash(string DateFrom, string DateTo)
    {
        string strQ = "";
        strQ += "SELECT IFNULL(TransactionType,'Total')TransactionType,SUM(AmtCash)AmtCash,SUM(AmtCreditCard)AmtCreditCard,SUM(AmtCheque)AmtCheque,SUM(AmtCredit)AmtCredit FROM ( ";
        strQ +="SELECT lm.LedgerName TransactionType,SUM(IF(rtp.PaymentModeID=1,rtp.Amount,0))AmtCash,  ";
        strQ +="SUM(IF(rtp.PaymentModeID=3,rtp.Amount,0))AmtCreditCard,SUM(IF(rtp.PaymentModeID=2,rtp.Amount,0))AmtCheque,0 AmtCredit  ";
        strQ += "FROM patient_medical_history adj LEFT JOIN f_reciept rt ON adj.TransactionID = rt.TransactionID AND rt.iscancel=0 AND rt.DeptLedgerNo NOT IN('LSHHI9151','LSHHI57')";
        strQ +="LEFT JOIN f_receipt_paymentdetail rtp ON rtp.ReceiptNo = rt.ReceiptNo ";
        strQ +="LEFT JOIN f_ledgermaster lm ON lm.LedgerNumber = rt.LedgerNoCr ";
        strQ += "WHERE rt.Date>='" + DateFrom + "' AND rt.Date <='" + DateTo + "'  ";
        strQ +="GROUP BY lm.LedgerName ";
        strQ +="UNION ALL ";
        strQ +="SELECT TransactionType,SUM(AmtCash)AmtCash,SUM(AmtCreditCard)AmtCreditCard,SUM(AmtCheque)AmtCheque, ";
        strQ +="SUM(NetAmount-AmountPaid)AmtCredit FROM ( ";
        strQ +="	SELECT 'IPD Outstanding' TransactionType,    ";    
        strQ +="	ROUND(IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail WHERE TransactionID=adj.TransactionID  ";
        strQ +="	AND IsVerified=1 AND IsPackage=0),0) - IFNULL(adj.DiscountOnBill,0))NetAmount,        ";
        strQ +="	ROUND(SUM(IFNULL(rt.AmountPaid,0)))AmountPaid,0 AmtCash,0 AmtCreditCard,0 AmtCheque  ";
        strQ +="	FROM (  ";
        strQ += "		SELECT TransactionID,DiscountOnBill,adj.BillNo FROM patient_medical_history adj WHERE  adj.TYPE='IPD'and DATE(adj.BillDate) >='" + DateFrom + "' AND DATE(adj.BillDate) <='" + DateTo + "'  "; 
        strQ +="		AND IFNULL(adj.BillNo,'')<>''  ";
        strQ += "	)adj LEFT JOIN f_reciept rt  ON rt.TransactionID = adj.TransactionID AND rt.IsCancel=0 AND rt.Date <='" + DateTo + "' ";
        strQ +="	GROUP BY adj.TransactionID ORDER BY adj.BillNo ";
        strQ += ")t GROUP BY TransactionType ";

        strQ +="UNION ALL ";
        strQ += "SELECT TransactionType,sum(AmtCash)AmtCash,sum(AmtCreditCard)AmtCreditCard, ";
        strQ += "sum(AmtCheque)AmtCheque, sum(AmtCredit)AmtCredit FROM ( ";
        strQ += "	SELECT 'OPD' AS ModeType, 	    IF(DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "','OPD SameDay Collection','OPD BackDay Collection')TransactionType,  ";	    
        strQ +="	'' IP_no,pm.PName PatientName,lt.BillNo,DATE_FORMAT(lt.Date,'%d-%b-%y')BillDate,  ";
        strQ += "	IF(DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "',IF(IsAdvanceAmt=1,0,lt.GrossAmount),0)GrossAmount, ";
        strQ += "	IF(DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "',IF(IsAdvanceAmt=1,0,lt.DiscountOnTotal),0)DiscountOnTotal, ";
        strQ += "	IF(DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "',IF(IsAdvanceAmt=1,0,lt.NetAmount),0)NetAmount,rt.ReceiptNo, ";
        strQ +="	DATE_FORMAT(rt.ReceiptDate,'%d-%b-%y')ReceiptDate,IFNULL(rt.AmountPaid,0)AmountPaid,IFNULL(rt.AmtCash,0)AmtCash, ";
        strQ +="	IFNULL(rt.AmtCreditCard,0)AmtCreditCard,rt.CreditCardNo,rt.CreditCardBankName, ";
        strQ +="	IFNULL(rt.AmtCheque,0)AmtCheque,rt.ChequeNo,rt.ChequeBankName,IF(rt.Cheque_DDdate='0001-01-01',NULL,DATE_FORMAT(Cheque_DDdate,'%d-%b-%y'))Cheque_DDdate, ";
        strQ +="	0 AmtCredit,lt.LedgerTransactionNO,lt.PanelID 	    FROM ( ";
        strQ +="		SELECT rt.ReceiptNo,rt.Date ReceiptDate,rt.AsainstLedgerTnxNo LedgerTransactionNO,rt.AmountPaid, ";
        strQ +="		IF(rtp.PaymentModeID=1,rtp.Amount,0)AmtCash, ";
        strQ +="		IF(rtp.PaymentModeID=3,rtp.Amount,0)AmtCreditCard, ";
        strQ +="		rtp.BankName CreditCardBankName,rtp.RefNo CreditCardNo, ";
        strQ +="		IF(rtp.PaymentModeID=2,rtp.Amount,0)AmtCheque,rtp.BankName ChequeBankName,rtp.RefNo ChequeNo, ";
        strQ +="		IF(DATE(rtp.RefDate)='0001-01-01','',DATE_FORMAT(rtp.RefDate,'%d-%b-%y'))Cheque_DDdate,0 IsAdvanceAmt ";
        strQ +="		FROM f_reciept rt INNER JOIN f_receipt_paymentdetail rtp ON rt.ReceiptNo = rtp.ReceiptNo  ";
        strQ += "		AND rt.IsCancel=0 AND rt.Date >='" + DateFrom + "' AND rt.Date <='" + DateTo + "' AND rt.AsainstLedgerTnxNo<>'' AND rt.DeptLedgerNo NOT IN('LSHHI9151','LSHHI57') "; //GROUP BY rt.ReceiptNo
        strQ +="		UNION ALL ";
        strQ +="		SELECT rt.ReceiptNo,rt.Date ReceiptDate,rt.AsainstLedgerTnxNo LedgerTransactionNO,rt.AmountPaid, ";
        strQ +="		IF(rtp.PaymentModeID=1,rtp.Amount,0)AmtCash, ";
        strQ +="		IF(rtp.PaymentModeID=3,rtp.Amount,0)AmtCreditCard, ";
        strQ +="		rtp.BankName CreditCardBankName,rtp.RefNo CreditCardNo, ";
        strQ +="		IF(rtp.PaymentModeID=2,rtp.Amount,0)AmtCheque,rtp.BankName ChequeBankName,rtp.RefNo ChequeNo, ";
        strQ +="		IF(DATE(rtp.RefDate)='0001-01-01','',DATE_FORMAT(rtp.RefDate,'%d-%b-%y'))Cheque_DDdate,pa.IsAdvanceAmt  ";
        strQ +="		FROM f_reciept rt INNER JOIN f_patientaccount pa ON rt.ReceiptNo = pa.ReceiptNo AND pa.IsAdvanceAmt=1  ";
        strQ += "		AND rt.date >='" + DateFrom + "' AND rt.date <='" + DateTo + "'     AND pa.Active=1 AND rt.IsCancel=0 ";
        strQ +="		INNER JOIN f_receipt_paymentdetail rtp ON rt.ReceiptNo = rtp.ReceiptNo AND rtp.PaymentModeID<>4 ";
        strQ += "		INNER JOIN f_reciept prt ON pa.ReceiptNoAgeinst = prt.ReceiptNo AND rt.DeptLedgerNo NOT IN('LSHHI9151','LSHHI57') ";
        strQ +="	)rt INNER JOIN f_ledgertransaction lt ON rt.LedgerTransactionNO = lt.LedgerTransactionNo ";
        strQ +="	INNER JOIN patient_master pm ON pm.PatientID = lt.PatientID  ";	    
        strQ +="	UNION ALL  ";	   
        strQ +="	SELECT 'OPD' AS ModeType,'OPD Outstanding' AS TransactionType,'' IP_no,pm.PName PatientName,lt.BillNo,DATE_FORMAT(lt.Date,'%d-%b-%y')BillDate, ";
        strQ += "	IF(DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "',IF(DATE(rt.Date)>='" + DateFrom + "' AND DATE(rt.Date)<='" + DateTo + "',0,lt.GrossAmount),0)GrossAmount, ";
        strQ += "	IF(DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "',IF(DATE(rt.Date)>='" + DateFrom + "' AND DATE(rt.Date)<='" + DateTo + "',0,lt.DiscountOnTotal),0)DiscountOnTotal, ";
        strQ += "	IF(DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "',IF(DATE(rt.Date)>='" + DateFrom + "' AND DATE(rt.Date)<='" + DateTo + "',0,lt.NetAmount),0)NetAmount, ";
        strQ +="	'' ReceiptNo,'' ReceiptDate,0 AmountPaid,IF(ltp.PaymentModeID=1,ltp.Amount,0)AmtCash, ";
        strQ +="	IF(ltp.PaymentModeID=3,ltp.Amount,0)AmtCreditCard,ltp.RefNo CreditCardNo,ltp.BankName CreditCardBankName, ";
        strQ +="	IF(ltp.PaymentModeID=2,ltp.Amount,0)AmtCheque,ltp.RefNo ChequeNo,ltp.BankName ChequeBankName, ";
        strQ +="	'' Cheque_DDdate,IF(ltp.PaymentModeID=4,ltp.Amount,0)AmtCredit,lt.LedgerTransactionNO,lt.PanelID  ";
        strQ +="	FROM f_ledgertransaction lt INNER JOIN patient_master pm ON lt.PatientID = pm.PatientID ";
        strQ +="	INNER JOIN f_ledgertransaction_paymentdetail ltp ON lt.LedgerTransactionNo = ltp.LedgerTransactionNo ";
        strQ +="	LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo=lt.LedgerTransactionNo AND rt.IsCancel=0  ";
        strQ += "	WHERE DATE(lt.date) >='" + DateFrom + "' AND DATE(lt.date) <='" + DateTo + "' ";
        strQ += "	AND lt.iscancel=0  AND lt.TypeOfTnx IN ('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-OTHERS','OPD-PACKAGE','OPD-BILLING','Emergency')  ";
        strQ +="	AND ltp.paymentmodeID = 4 GROUP BY lt.LedgerTransactionNo ";
        strQ += ")T WHERE TransactionType IN ('OPD SameDay Collection','OPD BackDay Collection','OPD Outstanding')   ";
        strQ += "group by TransactionType";
        strQ += ")t group by TransactionType with rollup";
        DataTable dt = StockReports.GetDataTable(strQ.ToString());
        return dt;
    }
}
