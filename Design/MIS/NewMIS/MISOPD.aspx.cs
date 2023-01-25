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
using System.Text;

public partial class Design_MIS_MISOPD : System.Web.UI.Page
{
     
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {           
            SelectType();
        }
    }

    private void SelectType()
    {
        string DateFrom = "", DateTo = "", SelectionType = "",DateType="1";

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
        
        switch (SelectionType)
        {
            case "OPD-CONSULTATION":
                ViewState["TypeofTnx"] = "'OPD-Appointment'";
                ViewState["ConfigIDs"] = "5";
                break;
            case "OPD-INVESTIGATIONS":
                ViewState["TypeofTnx"] = "'OPD-LAB','OPD-BILLING','OPD-PACKAGE'";
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

        LoadData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), DateType, ViewState["TypeofTnx"].ToString(), "OPD", ViewState["ConfigIDs"].ToString(), ViewState["SelectionType"].ToString());            
        
    }

    #region Overview

    protected void grdDoc_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string DocID = Util.GetString(e.CommandArgument);
            LoadDocDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["TypeofTnx"].ToString(), DocID, ViewState["ConfigIDs"].ToString());
            mpSelect.Show();
        }
    }
    protected void grdSpec_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string ItemID = Util.GetString(e.CommandArgument);
            LoadItemDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["TypeofTnx"].ToString(), ItemID, ViewState["ConfigIDs"].ToString());
            mpSelect.Show();
        }
    }
    protected void grdSubCat_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string SubCategoryID = Util.GetString(e.CommandArgument);
            LoadSubCatDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["TypeofTnx"].ToString(), SubCategoryID, ViewState["ConfigIDs"].ToString());
            mpSelect.Show();
        }
    }
    protected void grdPanel_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string PanelID = Util.GetString(e.CommandArgument);
            LoadPanelDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), ViewState["TypeofTnx"].ToString(), PanelID, ViewState["ConfigIDs"].ToString());
            mpSelect.Show();
        }
    }

    private void LoadData(string DateFrom, string DateTo, string DateType, string TypeofTnx, string OPDIPD, string ConfigIds, string SelectionType)
    {
        if (OPDIPD == "OPD")
        {
            if (TypeofTnx.ToUpper() == "'ALL'")
            {
                LoadALLOPD(DateFrom, DateTo, TypeofTnx);
                lblItemwise.Text = "Specialization-wise / Item-wise";
            }
            else if (TypeofTnx.ToUpper() == "'OPD-APPOINTMENT'")
            {
                LoadOPDAppointment(DateFrom, DateTo, TypeofTnx);
                lblItemwise.Text = "Specialization-wise";
            }
            else
            {
                LoadOPDData(DateFrom, DateTo, TypeofTnx,ConfigIds);
                lblItemwise.Text = "Service-wise / Item-wise";
            }

            lblClicked.Text = SelectionType;
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["TypeofTnx"] = TypeofTnx;
            ViewState["SelectionType"] = SelectionType;
        }

    }

    private void LoadALLOPD(string DateFrom, string DateTo, string TypeofTnx)
    {
        string strQ = "";

        //For Doctor-wise
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,DoctorID from ( ";
        strQ += "       SELECT dm.Name,t.Qty,t.Gross,t.Disc,t.Net,t.Collected,dm.DoctorID ";
        strQ += "       FROM (";
        strQ += "               SELECT ltd.TransactionID,ROUND(SUM(ltd.Quantity),2)Qty,";
        strQ += "               ROUND(SUM(Rate*Quantity))Gross,ROUND(SUM(Rate*Quantity)-SUM(Amount))Disc,";
        strQ += "               ROUND(SUM(Amount))Net,ROUND(SUM(ifnull(rt.AmountPaid,0)))Collected, sc.Name SubCategory,im.Type_ID ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "               LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-Appointment') ";
        strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "               AND DATE(lt.Date)<='" + DateTo + "' GROUP BY im.Type_ID ";
        strQ += "       )t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID";
        strQ += "       Union ALL ";
        strQ += "       SELECT NAME,ROUND(SUM(Qty))Qty,ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(IFNULL(Collected,0)))Collected,t1.DoctorID FROM( ";
        strQ += "               SELECT dm.Name,dm.DoctorID,ROUND(SUM(Quantity),2)Qty, ROUND(SUM(Gross))Gross, ";
        strQ += "               ROUND(SUM(Disc))Disc,ROUND(SUM(Net))Net,(SELECT IFNULL(AmountPaid,0) ";
        strQ += "               FROM f_reciept WHERE AsainstLedgerTnxNo = t.LedgerTransactionNo AND IsCancel=0)Collected ";
        strQ += "               FROM ( ";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity,(Rate*Quantity)Gross, ";
        strQ += "                       ((Rate*Quantity)-(Amount))Disc, ";
        strQ += "                       (Amount)Net,lt.LedgerTransactionNo FROM f_ledgertransaction lt ";
        strQ += "                       INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo WHERE lt.IsCancel = 0 ";
        strQ += "                       AND ltd.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        strQ += "                       AND DATE(lt.Date)>='" + DateFrom + "' AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "               INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        strQ += "               GROUP BY t.TransactionID ";
        strQ += "       )t1  GROUP BY t1.DoctorID ";
        strQ += ")t2 group by DoctorID ORDER BY NAME ";
        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);

            grdDoc.DataSource = dt;
            grdDoc.DataBind();
        }
        else
        {
            grdDoc.DataSource = null;
            grdDoc.DataBind();
        }


        //For Specialization-wise

        strQ = "";
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,ItemID from (   ";
        strQ += "       SELECT dm.Specialization Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,dm.Specialization ItemID ";
        strQ += "       FROM (";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "               Amount Net,im.Type_ID,ifnull(rt.AmountPaid,0)Collected ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "               LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-APPOINTMENT') ";
        strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "       )t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID  GROUP BY dm.Specialization ";
        strQ += "       UNION ALL ";
        strQ += "       SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,ItemID FROM ( ";
        strQ += "               SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "               IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,ItemID ";
        strQ += "               FROM ( ";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity, ";
        strQ += "                       (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "                       (Amount)Net,ltd.ItemID,im.typeName NAME ,IFNULL((SELECT AmountPaid ";
        strQ += "                       FROM f_reciept WHERE ";
        strQ += "                       AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "                       (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "                       WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "                       WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
        strQ += "                       AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "                       AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               )t ";
        strQ += "       )t1 GROUP BY ItemID  ";
        strQ += ")t2 Group by ItemID ORDER BY NAME";

        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdSpec.DataSource = dt;
            grdSpec.DataBind();

        }
        else
        {
            grdSpec.DataSource = null;
            grdSpec.DataBind();
        }

        //For SubCategory-wise

        strQ = "";
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,SubCategoryID from (   ";
        strQ += "       SELECT sc.Name,ROUND(SUM(ltd.Quantity),2)Qty,";
        strQ += "       ROUND(SUM(Rate*Quantity))Gross,ROUND(SUM(Rate*Quantity)-SUM(Amount))Disc,";
        strQ += "       ROUND(SUM(Amount))Net,ROUND(SUM(ifnull(rt.AmountPaid,0)))Collected,im.SubCategoryID ";
        strQ += "       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "       INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "       INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "       LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "       WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-APPOINTMENT') ";
        strQ += "       AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "       AND DATE(lt.Date)<='" + DateTo + "' GROUP BY ltd.SubCategoryID ";
        strQ += "       UNION ALL ";
        strQ += "       SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,SubCategoryID FROM ( ";
        strQ += "               SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "               IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,SubCategoryID ";
        strQ += "               FROM ( ";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity,ltd.SubCategoryID, ";
        strQ += "                       (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "                       (Amount)Net,ltd.ItemID,sc.NAME ,IFNULL((SELECT AmountPaid ";
        strQ += "                       FROM f_reciept WHERE ";
        strQ += "                       AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0),0)Collected, ";
        strQ += "                       (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "                       WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "                       INNER JOIN f_SubCategoryMaster sc ON im.SubCategoryID = sc.SubCategoryID ";
        strQ += "                       WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
        strQ += "                       AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "                       AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               )t ";
        strQ += "       )t1 GROUP BY SubCategoryID ";
        strQ += ")T2 Group By SubCategoryID order by Name ";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdSubCat.DataSource = dt;
            grdSubCat.DataBind();

        }
        else
        {
            grdSubCat.DataSource = null;
            grdSubCat.DataBind();
        }


        //For Panel-wise

        strQ = "";
        strQ += "SELECT Name,sum(Qty)Qty,sum(Gross)Gross,sum(Disc)Disc,sum(Net)Net,sum(Collected)Collected,PanelID from (   ";
        strQ += "       SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,pmh.PanelID ";
        strQ += "       FROM (";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "               Amount Net,ifnull(rt.AmountPaid,0) Collected ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-APPOINTMENT') ";
        strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "       )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "       INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY pmh.PanelID";
        strQ += "       UNION ALL ";
        strQ += "       SELECT Name,ROUND(SUM(Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,PanelID from ( ";
        strQ += "               SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "               ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "               ROUND(SUM(Net))Net,IFNULL((Select AmountPaid from f_reciept where ";
        strQ += "               AsainstLedgerTnxNo = t.LedgerTransactionNo and IsCancel=0 ),0)Collected,pmh.PanelID ";
        strQ += "               FROM (";
        strQ += "                       SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "                       (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "                       Amount Net,lt.LedgerTransactionNo ";
        strQ += "                       FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "                       ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "                       WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
        strQ += "                       AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "                       AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "               INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY t.LedgerTransactionNo";
        strQ += "       )t1 Group by PanelID ";
        strQ += ")t2 Group by PanelID order by Name ";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdPanel.DataSource = dt;
            grdPanel.DataBind();

        }
        else
        {
            grdPanel.DataSource = null;
            grdPanel.DataBind();
        }
    }

    private void LoadOPDAppointment(string DateFrom, string DateTo, string TypeofTnx)
    {
        string strQ = "";


        //For Doctor-wise

        //strQ += "SELECT dm.Name,dm.Specialization,t.Qty,t.Gross,t.Disc,t.Net,t.Collected,dm.DoctorID ";
        //strQ += "FROM (";
        //strQ += "    SELECT ltd.TransactionID,ROUND(SUM(ltd.Quantity),2)Qty,";
        //strQ += "    ROUND(SUM(Rate*Quantity))Gross,ROUND(SUM(Ltd.DiscAmt))Disc,";
        //strQ += "   SUM(ROUND((ltd.Rate*ltd.Quantity)-ROUND(ltd.DiscAmt,2)))Net,ROUND(SUM(ifnull(rt.AmountPaid,0)))Collected, sc.Name SubCategory,im.Type_ID ";
        //strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        //strQ += "    ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        //strQ += "    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        //strQ += "    INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        //strQ += "   LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        //strQ += "   WHERE lt.IsCancel = 0 AND  ltd.ConfigID=5 ";
        //strQ += "   AND DATE(lt.Date)>='" + DateFrom + "' ";
        //strQ += "   AND DATE(lt.Date)<='" + DateTo + "'  GROUP BY im.Type_ID ";
        //strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID";
        //strQ += " order by Name ";

        strQ += "Call NewMis_LoadAppDetail_Doctorwise('" + DateFrom + "','" + DateTo + "')";
        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);

            grdDoc.DataSource = dt;
            grdDoc.DataBind();
        }
        else
        {
            grdDoc.DataSource = null;
            grdDoc.DataBind();
        }


        //For Specialization-wise

        //strQ = "";
        //strQ += "SELECT dm.Specialization Name,ROUND(SUM(t.Qty),2)Qty,";
        //strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        //strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,dm.Specialization ItemID ";
        //strQ += "FROM (";
        //strQ += "    SELECT ltd.TransactionID,ltd.Quantity Qty,";
        //strQ += "    (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        //strQ += "    Amount Net,im.Type_ID,ifnull(rt.AmountPaid,0)Collected ";
        //strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        //strQ += "    ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        //strQ += "    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        //strQ += "    INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        //strQ += "   LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        //strQ += "   WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ";
        //strQ += "   AND DATE(lt.Date)>='" + DateFrom + "' ";
        //strQ += "   AND DATE(lt.Date)<='" + DateTo + "' ";
        //strQ += ")t INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID  GROUP BY dm.Specialization ";
        //strQ += " order by Specialization ";

        strQ = " call NewMis_LoadAppDetail_DoctorDept('" + DateFrom + "','" + DateTo + "')";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdSpec.DataSource = dt;
            grdSpec.DataBind();

        }
        else
        {
            grdSpec.DataSource = null;
            grdSpec.DataBind();
        }

        //For SubCategory-wise

        //strQ = "";
        //strQ += "    SELECT sc.Name,ROUND(SUM(ltd.Quantity),2)Qty,";
        //strQ += "    ROUND(SUM(Rate*Quantity))Gross,ROUND(SUM(Rate*Quantity)-SUM(Amount))Disc,";
        //strQ += "    ROUND(SUM(Amount))Net,ROUND(SUM(ifnull(rt.AmountPaid,0)))Collected,im.SubCategoryID ";
        //strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        //strQ += "    ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        //strQ += "    INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        //strQ += "    INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        //strQ += "    LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        //strQ += "    WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ";
        //strQ += "    AND DATE(lt.Date)>='" + DateFrom + "' ";
        //strQ += "    AND DATE(lt.Date)<='" + DateTo + "' GROUP BY ltd.SubCategoryID ";
        //strQ += " order by Name ";

        strQ = " call NewMis_LoadAppDetail_SubCategory('" + DateFrom + "','" + DateTo + "')";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdSubCat.DataSource = dt;
            grdSubCat.DataBind();

        }
        else
        {
            grdSubCat.DataSource = null;
            grdSubCat.DataBind();
        }


        //For Panel-wise

        //strQ = "";
        //strQ += "SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        //strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        //strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,pmh.PanelID ";
        //strQ += "FROM (";
        //strQ += "    SELECT ltd.TransactionID,ltd.Quantity Qty,";
        //strQ += "    (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        //strQ += "    Amount Net,ifnull(rt.AmountPaid,0) Collected ";
        //strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        //strQ += "    ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        //strQ += "    LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        //strQ += "   WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ";
        //strQ += "   AND DATE(lt.Date)>='" + DateFrom + "' ";
        //strQ += "   AND DATE(lt.Date)<='" + DateTo + "' ";
        //strQ += ")t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        //strQ += " INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY pmh.PanelID";
        //strQ += " order by Name ";

        strQ = " call NewMis_LoadAppDetail_Panelwise('" + DateFrom + "','" + DateTo + "')";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdPanel.DataSource = dt;
            grdPanel.DataBind();

        }
        else
        {
            grdPanel.DataSource = null;
            grdPanel.DataBind();
        }
    }

    private void LoadOPDData(string DateFrom, string DateTo, string TypeofTnx,string ConfigIDs)
    {
        string strQ = "";

        //For Doctor-wise

        strQ += "SELECT NAME,ROUND(SUM(Qty))Qty,ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(IFNULL(Collected,0)))Collected,t1.DoctorID FROM( ";
        strQ += "    SELECT dm.Name,dm.DoctorID,ROUND(SUM(Quantity),2)Qty, ROUND(SUM(Gross))Gross, ";
        strQ += "    ROUND(SUM(Disc))Disc,ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected ";
        strQ += "    FROM ( ";
        strQ += "           Select  TransactionID,Quantity,Gross,Disc,Net,LedgerTransactionNo,  ";
        strQ += "           IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected From ( ";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity,(Rate*Quantity)Gross,";
        strQ += "               (ltd.DiscAmt)Disc, ";
        strQ += "               (ltd.Rate*ltd.Quantity-DiscAmt)Net,lt.LedgerTransactionNo,(SELECT IFNULL(sum(AmountPaid),0) FROM f_reciept ";
        strQ += "               WHERE AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0 group by AsainstLedgerTnxNo )Collected, ";
        strQ += "               (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "               WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo WHERE lt.IsCancel = 0 ";
        strQ += "               AND ltd.TypeOfTnx IN(" + TypeofTnx + ") AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "           )t1 ";
        strQ += "    )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        strQ += "    GROUP BY t.TransactionID ";
        strQ += ")t1  GROUP BY t1.DoctorID ";
        strQ += "ORDER BY NAME ";

        DataTable dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {

            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);

            grdDoc.DataSource = dt;
            grdDoc.DataBind();
        }
        else
        {
            grdDoc.DataSource = null;
            grdDoc.DataBind();
        }


        //For Itemwise-wise
        strQ = "";

        strQ += "SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,ItemID FROM ( ";
        strQ += "       SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "       IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,ItemID ";
        strQ += "       FROM ( ";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity, ";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "               (Amount)Net,ltd.ItemID,im.typeName NAME ,IFNULL((SELECT sum(AmountPaid) ";
        strQ += "               FROM f_reciept WHERE ";
        strQ += "               AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0 group by AsainstLedgerTnxNo ),0)Collected, ";
        strQ += "               (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "               WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "       )t ";
        strQ += ")t1 GROUP BY ItemID ORDER BY NAME ";


        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdSpec.DataSource = dt;
            grdSpec.DataBind();

        }
        else
        {
            grdSpec.DataSource = null;
            grdSpec.DataBind();
        }

        //For SubCategory-wise

        strQ = "";
        strQ += "SELECT t1.Name,ROUND(SUM(Qty),2)Qty, ";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc, ";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,SubCategoryID FROM ( ";
        strQ += "       SELECT NAME,Quantity Qty,Gross,Disc,Net, ";
        strQ += "       IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected,TransactionID,SubCategoryID ";
        strQ += "       FROM ( ";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity,ltd.SubCategoryID, ";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-(Amount))Disc, ";
        strQ += "               (Amount)Net,ltd.ItemID,sc.NAME ,IFNULL((SELECT sum(AmountPaid) ";
        strQ += "               FROM f_reciept WHERE ";
        strQ += "               AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0 group by AsainstLedgerTnxNo ),0)Collected, ";
        strQ += "               (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "               WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "               INNER JOIN f_SubCategoryMaster sc ON im.SubCategoryID = sc.SubCategoryID ";
        strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "       )t ";
        strQ += ")t1 GROUP BY SubCategoryID ORDER BY NAME ";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdSubCat.DataSource = dt;
            grdSubCat.DataBind();

        }
        else
        {
            grdSubCat.DataSource = null;
            grdSubCat.DataBind();
        }


        //For Panel-wise

        strQ = "";
        strQ += "SELECT Name,ROUND(SUM(Qty),2)Qty,";
        strQ += "ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "ROUND(SUM(Net))Net,ROUND(SUM(Collected))Collected,PanelID from ( ";
        strQ += "       SELECT pnl.Company_Name Name,ROUND(SUM(t.Qty),2)Qty,";
        strQ += "       ROUND(SUM(Gross))Gross,ROUND(SUM(Disc))Disc,";
        strQ += "       ROUND(SUM(Net))Net,pmh.PanelID,ROUND(SUM(Collected))Collected ";
        strQ += "       FROM (";
        strQ += "           Select TransactionID,Qty,Gross,Disc,Net,LedgerTransactionNo,";
        strQ += "           IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)Collected FROM (";
        strQ += "               SELECT ltd.TransactionID,ltd.Quantity Qty,";
        strQ += "               (Rate*Quantity)Gross,((Rate*Quantity)-Amount) Disc,";
        strQ += "               Amount Net,lt.LedgerTransactionNo,IFNULL((SELECT sum(AmountPaid) FROM f_reciept WHERE";
        strQ += "               AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0 group by AsainstLedgerTnxNo),0)Collected, ";
        strQ += "               (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "               WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt ";
        strQ += "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "               ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ";
        strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "               AND ltd.ConfigID in (" + ConfigIDs + ") ";
        strQ += "           )t1 ";
        strQ += "       )t INNER JOIN Patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "       INNER JOIN f_Panel_master pnl ON pnl.PanelID = pmh.PanelID GROUP BY t.LedgerTransactionNo";
        strQ += ")t1 Group by PanelID order by Name ";
        dt = StockReports.GetDataTable(strQ);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
            dr["Collected"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            dt.Rows.Add(dr);
            grdPanel.DataSource = dt;
            grdPanel.DataBind();

        }
        else
        {
            grdPanel.DataSource = null;
            grdPanel.DataBind();
        }
    }

    private void LoadDocDetailData(string DateFrom, string DateTo, string TypeofTnx, string DocID,string ConfigIDs)
    {
        string strQ = "";
        if (TypeofTnx.ToUpper() == "'ALL'")
        {
            strQ = "Select Date,MR_No,PName,Age,Gender,DocName,Panel,Specialization,ReceiptNo,Gross,IFNULL(Disc,0)Disc,Net,Collected,LedgerTransactionNo FROM (  ";
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
            strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-APPOINTMENT') ";
            strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
            if(DocID!="")
            strQ += "               AND dm.DoctorID='" + DocID + "' ";
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
            strQ += "               WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN('OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING') ";
            strQ += "               AND DATE(lt.Date)>='" + DateFrom + "' ";
            strQ += "               AND DATE(lt.Date)<='" + DateTo + "' ";
               if(DocID!="")
            strQ += "               AND dm.DoctorID='" + DocID + "' ";
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
        }
        else if (TypeofTnx.ToUpper() == "'OPD-APPOINTMENT'")
        {

            //strQ += "SELECT t.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,pm.Age,pm.Gender,DocName,Panel, ";
            //strQ += "Specialization,IF(rt.ReceiptNo IS NULL,t.BillNo,rt.ReceiptNo)ReceiptNo,Gross,IFNULL(Disc,0)Disc,Net, ";
            //strQ += "IFNULL((AmountPaid),0)Collected,t.LedgerTransactionNo FROM ( ";
            //strQ += "    SELECT lt.TransactionID,lt.PatientID,dm.Name DocName,pnl.Company_Name Panel, ";
            //strQ += "    dm.Specialization,ROUND(SUM(ltd.Rate*ltd.Quantity))Gross, ";
            //strQ += "    ROUND(SUM(ltd.DiscAmt))Disc,ROUND(SUM(SUM(ltd.Rate*ltd.Quantity-ltd.DiscAmt)))Net, ";
            //strQ += "    DATE_FORMAT(lt.date,'%d-%b-%y')DATE,lt.LedgerTransactionNo,lt.BillNo ";
            //strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ";
            //strQ += "    lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN f_itemmaster im ON  ";
            //strQ += "    ltd.ItemID = im.ItemID INNER JOIN doctor_master dm ON dm.DoctorID = im.Type_ID ";
            //strQ += "    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ";
            //strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
            //strQ += "    WHERE lt.IsCancel = 0 AND ltd.ConfigID=5 ";
            //strQ += "    AND DATE(lt.Date)>='" + DateFrom + "' ";
            //strQ += "    AND DATE(lt.Date)<='" + DateTo + "' ";
            //   if(DocID!="")
            //strQ += "               AND dm.DoctorID='" + DocID + "' ";
            //strQ += "    GROUP BY ltd.LedgerTransactionNo ";
            //strQ += ")t INNER JOIN patient_master pm ON t.PatientID= pm.PatientID ";
            //strQ += "LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = t.LedgerTransactionNo ";

            strQ = "Call NewMis_LoadAppDetail_Doctor_Detail('" + DateFrom + "','" + DateTo + "'," + DocID + ")";

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
        }
        else
        {
            //strQ += "SELECT t.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,pm.Age,pm.Gender,DocName,Panel, ";
            //strQ += "Specialization,IF(rt.ReceiptNo IS NULL,t.BillNo,rt.ReceiptNo)ReceiptNo,Gross,IFNULL(Disc,0)Disc,Net, ";
            //strQ += "IFNULL((AmountPaid),0)Collected,t.LedgerTransactionNo FROM ( ";
            //strQ += "    SELECT lt.TransactionID,lt.PatientID,dm.Name DocName,pnl.Company_Name Panel, ";
            //strQ += "    dm.Specialization,ROUND(SUM(ltd.Rate*ltd.Quantity))Gross, ";
            //strQ += "    ROUND(SUM((ltd.Rate*ltd.Quantity)-Amount))Disc,ROUND(SUM(ltd.Amount))Net, ";
            //strQ += "    DATE_FORMAT(lt.date,'%d-%b-%y')DATE,lt.LedgerTransactionNo,lt.BillNo ";
            //strQ += "    FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON ";
            //strQ += "    lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ";
            //strQ += "    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID ";
            //strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
            //strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
            //strQ += "    WHERE lt.IsCancel = 0 AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ";
            //strQ += "    AND ltd.ConfigID in (" + ConfigIDs + ") ";
            //strQ += "    AND DATE(lt.Date)>='" + DateFrom + "' ";
            //strQ += "    AND DATE(lt.Date)<='" + DateTo + "' ";
            //if (DocID != "")
            //    strQ += "                   AND dm.DoctorID='" + DocID + "' ";
            //strQ += "    GROUP BY ltd.LedgerTransactionNo ";
            //strQ += ")t INNER JOIN patient_master pm ON t.PatientID= pm.PatientID ";
            //strQ += "LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = t.LedgerTransactionNo ";

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT t.Date,REPLACE(pm.PatientID,'LSHHI','')MR_No,pm.PName,pm.Age,pm.Gender,DocName,Panel,  ");
            sb.Append("Specialization,IF(t.ReceiptNo IS NULL,t.BillNo,t.ReceiptNo)ReceiptNo,SUM(Gross)Gross,IFNULL(SUM(Disc),0)Disc,SUM(Net)Net,  ");
            sb.Append("ROUND(SUM(IFNULL(((Net * ((Collected/BillAmt)*100))/100),0))) Collected,t.LedgerTransactionNo FROM (  ");
            sb.Append("SELECT lt.TransactionID,lt.PatientID,dm.Name DocName,pnl.Company_Name Panel,  ");
            sb.Append("dm.Specialization,ROUND((ltd.Rate*ltd.Quantity))Gross,  ");
            sb.Append("ROUND((ltd.DiscAmt))Disc,ROUND(((ltd.Rate*ltd.Quantity-ltd.DiscAmt)))Net,  ");
            sb.Append("DATE_FORMAT(lt.date,'%d-%b-%y')DATE,lt.LedgerTransactionNo,lt.BillNo , ");
            sb.Append("IFNULL((AmountPaid),0)Collected, ");
            sb.Append("(SELECT SUM(Amount)  FROM f_ledgertnxdetail WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,rt.ReceiptNo ");
            sb.Append("FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON  ");
            sb.Append("lt.LedgerTransactionNo = ltd.LedgerTransactionNo INNER JOIN f_itemmaster im ON   ");
            sb.Append("ltd.ItemID = im.ItemID INNER JOIN doctor_master dm ON dm.DoctorID = ltd.DoctorID  ");
            sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID = lt.TransactionID  ");
            sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID  ");
            sb.Append("LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo  ");
            sb.Append("WHERE lt.IsCancel = 0  AND ltd.ConfigID in (" + ConfigIDs + ") AND ltd.TypeOfTnx IN(" + TypeofTnx + ") ");
            sb.Append(" AND DATE(lt.Date)>='" + DateFrom + "' ");
            sb.Append(" AND DATE(lt.Date)<='" + DateTo + "' ");
            sb.Append("AND dm.DoctorID='" + DocID + "' ");
            sb.Append(")t INNER JOIN patient_master pm ON t.PatientID= pm.PatientID GROUP BY t.LedgerTransactionNo ; ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                grdDetails.DataSource = dt;
                grdDetails.DataBind();

                ((Label)grdDetails.FooterRow.FindControl("lblGrossT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblDiscT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblNetT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
                ((Label)grdDetails.FooterRow.FindControl("lblCollectedT")).Text = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Collected)", ""))));
            }
        }
    }

    private void LoadItemDetailData(string DateFrom, string DateTo, string TypeofTnx, string ItemID,string ConfigIDs)
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
        strQ += "        (Rate*Quantity)Gross,(DiscAmt)Disc, ";
        strQ += "        ((Rate*Quantity)-(DiscAmt))Net,ltd.ItemID,im.typeName NAME ,IFNULL(AmountPaid,0)Collected, ";
        strQ += "        (SELECT SUM(Amount)  FROM f_ledgertnxdetail ";
        strQ += "        WHERE LedgerTransactionNO=ltd.LedgerTransactionNo)BillAmt,";
        strQ += "        IF(rt.ReceiptNo IS NULL,lt.BillNo,rt.ReceiptNo)ReceiptNo,lt.LedgerTransactionNo,im.Type_ID ";
        strQ += "        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ";
        strQ += "        ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ";
        strQ += "        INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID ";
        strQ += "        LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo ";
        strQ += "        AND rt.IsCancel=0 ";
        strQ += "        WHERE lt.IsCancel = 0  ";

        if (TypeofTnx.ToUpper() == "'ALL'")
            strQ += "        AND ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        else
            strQ += "        AND ltd.ConfigID=5 ";

        if (TypeofTnx.ToUpper() != "'ALL'")
            strQ += "        AND ltd.ConfigID in (" + ConfigIDs + ") ";

        strQ += "        AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "        AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = t.Type_ID ";
        if (ItemID != "")
        {
            if (TypeofTnx.ToUpper() == "'OPD-APPOINTMENT'")
                strQ += "    WHERE dm.Specialization='" + ItemID + "' ";
            else
                strQ += "    WHERE t.ItemID='" + ItemID + "' ";
        }

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

    }

    private void LoadSubCatDetailData(string DateFrom, string DateTo, string TypeofTnx, string SubCategoryID, string ConfigIDs)
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
            strQ += "        AND ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        else
            strQ += "        AND ltd.TypeOfTnx IN(" + TypeofTnx + ")  ";

        if (TypeofTnx.ToUpper() != "'ALL'")
            strQ += "        AND ltd.ConfigID in (" + ConfigIDs + ") ";

        strQ += "        AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "        AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        if(SubCategoryID !="")
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

    }

    private void LoadPanelDetailData(string DateFrom, string DateTo, string TypeofTnx, string PanelID, string ConfigIDs)
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
            strQ += "        AND ltd.TypeOfTnx IN('OPD-APPOINTMENT','OPD-LAB','OPD-PROCEDURE','OPD-PACKAGE','OPD-OTHERS','OPD-BILLING')  ";
        else
            strQ += "        AND ltd.TypeOfTnx IN(" + TypeofTnx + ")  ";
        
        if (TypeofTnx.ToUpper() != "'ALL'")
            strQ += "        AND ltd.ConfigID in (" + ConfigIDs + ") ";

        strQ += "        AND DATE(lt.Date)>='" + DateFrom + "' ";
        strQ += "        AND DATE(lt.Date)<='" + DateTo + "' ";
        strQ += "    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ";
        strQ += "    INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ";
        strQ += "    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ";
        if(PanelID!="")
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
            HtmlGenericControl HgcDiv = new HtmlGenericControl();
           HgcDiv = (HtmlGenericControl)e.Row.FindControl("dvDetail");
          //  HgcDiv.InnerText = strDetail;

            e.Row.Attributes.Add("onmouseover", "javascript:showTip(event," + HgcDiv + ");");
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
            Detail += "            S.No.</td>";
            Detail += "        <td style='width: 50%' class='ItDoseLblSpBl'>";
            Detail += "            Item Name</td>";
            Detail += "        <td align='center' style='width: 6%' class='ItDoseLblSpBl'>";
            Detail += "            Qty.</td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>";
            Detail += "            Rate</td>";
            Detail += "        <td align='right' style='width: 13%' class='ItDoseLblSpBl'>";
            Detail += "            Disc.</td>";
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
                Detail += "        <td align='right' style='width: 13%' class='ItDoseLabelSp'>" + Util.GetString(Math.Round(Util.GetDecimal(dt.Rows[i]["Disc"]),2));
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

    #endregion Overview

    protected void grdDoc_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
