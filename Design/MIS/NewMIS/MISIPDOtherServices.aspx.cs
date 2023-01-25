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

public partial class Design_MIS_MISIPDOtherServices : System.Web.UI.Page
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

        LoadData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), DateType, "", "IPD", "", ViewState["SelectionType"].ToString());            
        
    }

    #region Overview

    protected void grdDoc_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string DocID = Util.GetString(e.CommandArgument);
            LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "DoctorID", ViewState["DateType"].ToString(), DocID, ViewState["SelectionType"].ToString());
            mpSelect.Show();
        }
    }
    protected void grdSpec_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string ItemID = Util.GetString(e.CommandArgument);
            LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "ItemID", ViewState["DateType"].ToString(), ItemID, ViewState["SelectionType"].ToString());
            mpSelect.Show();
        }
    }
    protected void grdSubCat_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string SubCategoryID = Util.GetString(e.CommandArgument);
            LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "SubCategoryID", ViewState["DateType"].ToString(), SubCategoryID, ViewState["SelectionType"].ToString());
            mpSelect.Show();
        }
    }
    protected void grdPanel_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string PanelID = Util.GetString(e.CommandArgument);
            LoadDetailData(ViewState["DateFrom"].ToString(), ViewState["DateTo"].ToString(), "PanelID", ViewState["DateType"].ToString(), PanelID, ViewState["SelectionType"].ToString());
            mpSelect.Show();
        }
    }

    private void LoadData(string DateFrom, string DateTo, string DateType, string TypeofTnx, string OPDIPD, string ConfigIds, string SelectionType)
    {
        if (OPDIPD == "IPD")
        {
            LoadIPDData(DateFrom, DateTo, TypeofTnx, DateType, SelectionType);
            lblItemwise.Text = "Service-wise / Item-wise";        

            lblClicked.Text = SelectionType;
            ViewState["DateFrom"] = DateFrom;
            ViewState["DateTo"] = DateTo;
            ViewState["TypeofTnx"] = TypeofTnx;
            ViewState["SelectionType"] = SelectionType;
        }

    }

    private void LoadIPDData(string DateFrom, string DateTo, string TypeofTnx,string DateType,string SelectionType)
    {

        //Doctorwise
        DataTable dt = LoadIPDGrids(DateFrom, DateTo, "DoctorID", DateType, SelectionType);

        if (dt != null && dt.Rows.Count > 0)
        {

            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));            
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
        dt = LoadIPDGrids(DateFrom, DateTo, "ItemID", DateType, SelectionType);

        if (dt != null && dt.Rows.Count > 0)
        {

            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
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

        dt = LoadIPDGrids(DateFrom, DateTo, "SubCategoryID", DateType, SelectionType);

        if (dt != null && dt.Rows.Count > 0)
        {

            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
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

        dt = LoadIPDGrids(DateFrom, DateTo, "PanelID", DateType, SelectionType);

        if (dt != null && dt.Rows.Count > 0)
        {

            DataRow dr = dt.NewRow();
            dr[0] = "Total";
            dr["Qty"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Qty)", ""))));
            dr["Gross"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Gross)", ""))));
            dr["Disc"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Disc)", ""))));
            dr["Net"] = Util.GetString(Math.Round(Util.GetDecimal(dt.Compute("sum(Net)", ""))));
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

    private DataTable LoadIPDGrids(string DateFrom, string DateTo, string FilterType, string DateType, string SelectionType)
    { 
        string strQ = "";
        strQ += "SELECT  ";
       
        if(FilterType=="DoctorID")
            strQ += "dm.Name, ";
        else if (FilterType == "ItemID")
        {
            if(SelectionType.ToUpper()=="SURGERY CHARGES")
                strQ += "sm.Name, ";
            else
                strQ += "im.TypeName Name, ";

        }
        else if (FilterType == "SubCategoryID")
        {
            if(SelectionType.ToUpper()=="SURGERY CHARGES")
                strQ += "IF(IFNULL(sm.SubDepartment,'')='',sm.Department,sm.SubDepartment)Name, ";
            else
                strQ += "sm.Name, ";
        }            
        else if(FilterType=="PanelID")
            strQ += "pnl.Company_Name Name, ";

        strQ += "Round(SUM(Qty),2)Qty,Round(SUM(Gross),2)Gross,ROUND(SUM(Disc),2)Disc,";
        strQ += "ROUND(SUM(Net),2)Net,t.DoctorID,t.PanelID,t.SubCategoryID,t.ItemID FROM ( ";
        strQ += "       SELECT IF(ltd.IsPackage=0,(ltd.Rate*ltd.Quantity),0)Gross,ucase(sc.DisplayName)DisplayName, ";
        strQ += "      ROUND(ltd.DiscAmt,2)Disc,((ltd.Rate*ltd.Quantity)-ROUND(ltd.DiscAmt,2)) Net,ltd.Quantity Qty,";
        strQ += "       IF(IFNULL(ltd.DoctorID,'')='',adj.DoctorID,ltd.DoctorID)DoctorID,";
        strQ += "       if(ltd.Surgery_ID='',ltd.SubCategoryID,ltd.Surgery_ID)SubCategoryID,";
        strQ += "       if(ltd.Surgery_ID='',ltd.ItemID,ltd.Surgery_ID)ItemID,ltd.Surgery_ID,adj.PanelID PanelID ";
        strQ += "       FROM f_ipdadjustment adj INNER JOIN f_ledgertnxdetail ltd ON ";
        strQ += "       adj.TransactionID = ltd.TransactionID ";
        strQ += "       INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "       INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "       WHERE ltd.IsVerified=1 AND ltd.TransactionID LIKE 'ishhi%'  AND ltd.IsPackage=0 ";

        if (DateType == "1")
        {
            strQ += "   AND DATE(adj.BillDate)>='" + DateFrom + "' AND DATE(adj.BillDate)<='" + DateTo + "' ";
            strQ += "   AND ifnull(adj.BillNo,'')<>'' ";
        }
        else
            strQ += "   AND DATE(ltd.EntryDate)>='" + DateFrom + "' AND DATE(ltd.EntryDate)<='" + DateTo + " ' ";

        strQ += "       AND IF(IFNULL(sc.DisplayName,''),sc.Name,sc.DisplayName)='" + SelectionType + "' ";
        strQ += ")t  "; 
              

        if (FilterType == "DoctorID")
            strQ += " INNER JOIN doctor_master dm ON dm.DoctorID = t.DoctorID GROUP BY dm.DoctorID";
        else if (FilterType == "ItemID")
        {            
            if (SelectionType.ToUpper() == "SURGERY CHARGES")
                strQ += " INNER JOIN f_surgery_master sm ON sm.Surgery_ID = t.Surgery_ID GROUP BY sm.Surgery_ID ";
            else
                strQ += " INNER JOIN f_ItemMaster im ON im.ItemID = t.ItemID GROUP BY im.ItemID ";
        }
        else if (FilterType == "SubCategoryID")
        {            
            if (SelectionType.ToUpper() == "SURGERY CHARGES")
                strQ += " INNER JOIN f_surgery_master sm ON sm.Surgery_ID = t.Surgery_ID GROUP BY IF(IFNULL(sm.SubDepartment,'')='',sm.Department,sm.SubDepartment) ";
            else
                strQ += " INNER JOIN f_SubCategorymaster sm ON sm.SubCategoryID = t.SubCategoryID GROUP BY t.SubCategoryID";
        }
        else if (FilterType == "PanelID")
            strQ += " INNER JOIN f_Panel_master pnl ON pnl.PanelID = t.PanelID GROUP BY t.PanelID";

        if (FilterType == "DoctorID")
            strQ += " order by dm.Name ";
        else if (FilterType == "ItemID")
        {
            if (SelectionType.ToUpper() == "SURGERY CHARGES")
                strQ += " order by sm.Name ";
            else
                strQ += " order by im.TypeName ";
        }
        else if (FilterType == "SubCategoryID")
        {
            if (SelectionType.ToUpper() == "SURGERY CHARGES")
                strQ += " order by IF(IFNULL(sm.SubDepartment,'')='',sm.Department,sm.SubDepartment)";
            else
                strQ += " order by sm.Name ";
        }
        else if (FilterType == "PanelID")
            strQ += " order by pnl.Company_Name  ";


        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQ);
        return dt;
    }

    private void LoadDetailData(string DateFrom, string DateTo, string FilterType, string DateType, string ID, string SelectionType)
    {
        string strQ = "";
        strQ += "SELECT  DATE,REPLACE(t.PatientID,'LSHHI','')MR_No,REPLACE(t.TransactionID,'ISHHI','')IP_No,";
        strQ += "(SELECT PName FROM Patient_master WHERE PatientID=t.PatientID)Pname,";
        strQ += "(SELECT NAME FROM employee_master WHERE employee_ID=t.UserID)GivenBy,";
        strQ += "(SELECT company_Name FROM f_panel_master WHERE PanelID=t.PanelID)Panel,";
        strQ += "(SELECT NAME FROM doctor_Master WHERE DoctorID=t.DoctorID)DocName,";

        if(SelectionType.ToUpper()=="SURGERY CHARGES")
            strQ += "(SELECT if(IfNull(SubDepartment,'')='',Department,SubDepartment) FROM f_Surgery_master WHERE Surgery_ID=t.Surgery_ID)Department,Concat((SELECT Name FROM f_Surgery_master WHERE Surgery_ID=t.Surgery_ID),'/',t.itemname)ItemName,";
        else
            strQ += "t.Department,";

        strQ += "Qty,Gross,Disc,Net,itemname ";
        strQ += "FROM (     ";
        strQ += "               SELECT ltd.itemname,IF(ltd.IsPackage=0,(ltd.Rate*ltd.Quantity),0)Gross,ucase(sc.DisplayName)DisplayName, ";
        strQ += "               ROUND(ltd.TotalDiscAmt,2)Disc,ltd.NetItemAmt Net,ltd.Quantity Qty, ";
        strQ += "               sc.Name Department,ltd.Surgery_ID, ";
        strQ += "               IF(IFNULL(ltd.DoctorID,'')='',adj.DoctorID,ltd.DoctorID)DoctorID,adj.PanelID PanelID,ltd.SubCategoryID,ltd.ItemID,  ";
        strQ += "               DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')DATE,ltd.UserID,adj.PatientID,adj.TransactionID ";
        strQ += "               FROM f_ipdadjustment adj INNER JOIN f_ledgertnxdetail ltd ON ";
        strQ += "               adj.TransactionID = ltd.TransactionID ";
        strQ += "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID ";
        strQ += "               INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQ += "               WHERE ltd.IsVerified=1 AND ltd.TransactionID LIKE 'ishhi%' ";

        if (DateType == "1")
        {
            strQ += "           AND DATE(adj.BillDate)>='" + DateFrom + "' AND DATE(adj.BillDate)<='" + DateTo + "' ";
            strQ += "           AND ifnull(adj.BillNo,'')<>'' ";
        }
        else
            strQ += "           AND DATE(ltd.EntryDate)>='" + DateFrom + "' AND DATE(ltd.EntryDate)<='" + DateTo + "' ";

        strQ += "               AND IF(IFNULL(sc.DisplayName,''),sc.Name,sc.DisplayName)='" + SelectionType + "' ";
        strQ += ")t  "; 

        if (FilterType == "DoctorID" && ID !="")
            strQ += " Where t.DoctorID ='" + ID + "'";
        else if (FilterType == "ItemID" && ID != "")
        {
            if (SelectionType.ToUpper() == "SURGERY CHARGES")
                strQ += " INNER JOIN f_surgery_master sm ON sm.Surgery_ID = t.Surgery_ID Where t.Surgery_ID ='" + ID + "' ";
            else
                strQ += " Where t.ItemID ='" + ID + "'";            
        }
        else if (FilterType == "SubCategoryID" && ID != "")
        {            
            if (SelectionType.ToUpper() == "SURGERY CHARGES")
                strQ += " INNER JOIN f_surgery_master sm ON sm.Surgery_ID = t.Surgery_ID Where if(IfNull(sm.SubDepartment,'')='',sm.Department,sm.SubDepartment) in (Select if(IfNull(SubDepartment,'')='',Department,SubDepartment) from f_surgery_master where Surgery_ID='" + ID + "') ";
            else
                strQ += " Where t.SubCategoryID ='" + ID + "'";
        }
        else if (FilterType == "PanelID" && ID != "")
            strQ += " Where t.PanelID ='" + ID + "'";

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
   
    protected void grdDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            
            
        }

    }
   
    #endregion Overview
    
}
