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
using System.IO;

public partial class Design_Finance_ServicewiseBillingDetai : System.Web.UI.Page
{
    public override void VerifyRenderingInServerForm(Control control)
    {
        return;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.SetCurrentDate();
            ucToDate.SetCurrentDate();
            BindDoctors();
        }
    }

    private void BindDoctors()
    {
        string str = "select DoctorID,Name DName from doctor_master where IsActive = " + rbtActive.SelectedValue + " order by Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dt;
            ddlDoctor.DataTextField = "DName";
            ddlDoctor.DataValueField = "DoctorID";
            ddlDoctor.DataBind();

            ddlDoctor.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
        else
            ddlDoctor.Items.Clear();
    }

    protected void rbtActive_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDoctors();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        ////string str = "" +
        ////"SELECT MrNo,IPDNo,BillType,Upper(PName)PName,Upper(MainConsultant)MainConsultant,Upper(Department)Department,if(ifnull(OnConsultant,'')='',Upper(MainConsultant),Upper(OnConsultant))OnConsultant,Upper(Panel)Panel,BillNo,Date_Format(BillDate,'%d-%b-%y')BillDate," +
        ////"Date_Format(DateOfEntry,'%d-%b-%y')DateOfEntry,UPPER(MainGroup)MainGroup,UPPER(SubGroup)SubGroup,UPPER(SurgeryName)SurgeryName,IsPackage,UPPER(IFNULL(PackageName,''))PackageName,UPPER(ItemName)ItemName,Rate,Quantity,DiscAmt,Amount,UPPER(User)User FROM ( " +
        ////"    SELECT REPLACE(pmh.PatientID,'LSHHI','')MrNo,'' IPDNo,pm.PName,dm.Name MainConsultant,(SELECT Department FROM doctor_hospital " + 
        ////"    WHERE DoctorID=dm.DoctorID LIMIT 1)Department,MainGroup,SubGroup, " +
        ////"    dm.Name OnConsultant,t.BillType,IF(rt.ReceiptNo IS NULL,t.BillNo,rt.ReceiptNo)BillNo,IF(rt.Date IS NULL,t.date,rt.Date)BillDate,t.Date DateOfEntry, " +
        ////"    SurgeryName,'NO' IsPackage,'' PackageName,t.ItemName,t.Rate,t.Quantity,t.DiscAmt,t.Amount,User,(Select Company_name from f_panel_master where PanelID=pmh.PanelID)Panel " +
        ////"    FROM ( " +
        ////"        SELECT lt.BillNo,lt.date,ltd.ItemName,lt.TransactionID,ltd.Rate,ltd.Quantity,ltd.Amount, " +
        ////"        ((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100))DiscAmt,ltd.IsPackage,ltd.PackageID, " +
        ////"        lt.LedgerTransactionNo ,'OPD' BillType,lt.TypeOfTnx,sc.DisplayName MainGroup,sc.Name SubGroup, " +
        ////"        '' SurgeryName,(Select Name from employee_Master where employee_ID=lt.Creator_UserID)User " +
        ////"        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo " +
        ////"        INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID =ltd.SubCategoryID " +
        ////"        WHERE DATE(lt.date)>='" + ucFromDate.GetDateForDataBase() + "' AND DATE(lt.date)<='" + ucToDate.GetDateForDataBase() + "' " +
        ////"        AND lt.TypeOfTnx IN ('opd-appointment','opd-lab','opd-procedure','opd-other','opd-package','CASUALTY-BILLING') and lt.Iscancel=0 " +
        ////"    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID " +
        ////"    INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID " +
        ////"    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID " +
        ////"    LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = t.LedgerTransactionNo and rt.Iscancel=0  " +
        ////"    UNION ALL " +
        ////"    SELECT REPLACE(pmh.PatientID,'LSHHI','')MrNo,REPLACE(t.TransactionID,'ISHHI','')IPDNo,pm.PName,dm.Name MainConsultant, " +
        ////"    (SELECT Department FROM doctor_hospital WHERE DoctorID=dm.DoctorID LIMIT 1)Department,MainGroup,SubGroup, " +
        ////"    dms.Name OnConsultant,t.BillType,adj.BillNo,t.BillDate,t.EntryDate DateOfEntry,SurgeryName,IF(IsPackage=0,'NO','YES')IsPackage,(SELECT typename  FROM f_itemmaster WHERE itemid=t.PackageID)PackageName,t.ItemName,t.Rate,t.Quantity,t.DiscAmt,t.Amount, " +
        ////"    User,(Select Company_name from f_panel_master where PanelID=pmh.PanelID)Panel FROM ( " +
        ////"        SELECT lt.BillNo,lt.BillDate,ltd.ItemName,lt.TransactionID,ltd.Rate,ltd.Quantity,ltd.Amount,ltd.DoctorID, " +
        ////"        ((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100))DiscAmt,ltd.IsPackage,ltd.PackageID, " +
        ////"        lt.LedgerTransactionNo ,'IPD' BillType,lt.TypeOfTnx,sc.DisplayName MainGroup,sc.Name SubGroup,ltd.EntryDate, " +
        ////"        ltd.SurgeryName,(Select Name from employee_Master where employee_ID=ltd.UserID)User " +
        ////"        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo " +
        ////"        INNER JOIN f_Itemmaster im ON im.ItemID = ltd.ItemID " +
        ////"        INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID =ltd.SubCategoryID " +
        ////"        WHERE DATE(lt.BillDate)>='" + ucFromDate.GetDateForDataBase() + "' AND DATE(lt.BillDate)<='" + ucToDate.GetDateForDataBase() + "' "+
        ////"        AND ltd.IsVerified=1  " +
        ////"        AND IF(DATE(lt.BillDate) <= '2012-01-02',1,IF(IFNULL(im.Type_ID,'')='HS',IFNULL(im.ServiceItemID,'')<>'',IFNULL(im.Type_ID,'')<>'HS')) " +
        ////"    )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID " +
        ////"    INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID " +
        ////"    INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID " +
        ////"    INNER JOIN f_ipdadjustment adj ON adj.TransactionID = pmh.TransactionID " +
        ////"    LEFT JOIN doctor_master dmS ON dms.DoctorID = t.DoctorID " +
        ////")t1 ORDER BY BillNo,BillDate";

        dt = LoadDetail();

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDetail.DataSource = dt;
            grdDetail.DataBind();
            btnExport.Visible = true;
            btnOpenOffice.Visible = true;
        }
        else
        {
            lblMsg.Text = "No Record Found";
            btnExport.Visible = false;
            btnOpenOffice.Visible = false;
        }


    }

    private DataTable LoadDetail()
    {
        DataTable dt = new DataTable();
        string str = "" +
        "SELECT Consultant,ROUND(SUM(OPDTotal))OPDTotal,ROUND(SUM(OPD_Consultation))OPDConsult, " +
        "ROUND(SUM(Casualty))Casualty,ROUND(SUM(OPDInvestigation))OPDInvest, " +
        "ROUND(SUM(OPDProcedure))OPDPro,ROUND(SUM(OPDPackage))OPDPkg, " +
        "ROUND(SUM(OPDOther))OPDOth, " +
        "ROUND(SUM(IPDTotal))IPDTotal,ROUND(SUM(IPD_Consultation))IPDVisit, " +
        "ROUND(SUM(IPD_CrossConsultation))IPDCrossConsult, " +
        "ROUND(SUM(IPDInvestigation))IPDInvest,ROUND(SUM(IPDMinorProcedure))IPDMinorPro, " +
        "ROUND(SUM(IPDSurgery))IPDSurgery,ROUND(SUM(IPDPackage))IPDPkg,ROUND(SUM(IPDRoom))IPDRoom, " +
        "ROUND(SUM(IPDMedCons))IPDMedCons,ROUND(SUM(IPDOther))IPDOther, " +
        "(ROUND(SUM(OPDTotal))+ ROUND(SUM(IPDTotal)))Total FROM ( " +
        "    SELECT IF(IFNULL(OnConsultant,'')='',UPPER(MainConsultant),UPPER(OnConsultant))Consultant, " +
        "    IF(t1.BillType='OPD',(t1.Amount),0)OPDTotal, " +
        "    IF(t1.BillType='IPD',(t1.Amount),0)IPDTotal, " +
        "    (CASE WHEN BillType='OPD' AND ConfigID =5 THEN t1.Amount ELSE 0 END)OPD_Consultation, " +
        "    (CASE WHEN BillType='OPD' AND ConfigID =4 THEN t1.Amount ELSE 0 END)Casualty, " +
        "    (CASE WHEN BillType='OPD' AND ConfigID =3 THEN t1.Amount ELSE 0 END)OPDInvestigation, " +
        "    (CASE WHEN BillType='OPD' AND ConfigID =25 THEN t1.Amount ELSE 0 END)OPDProcedure, " +
        "    (CASE WHEN BillType='OPD' AND ConfigID =23 THEN t1.Amount ELSE 0 END)OPDPackage, " +
        "    (CASE WHEN BillType='OPD' AND ConfigID NOT IN (3,4,5,23,25) THEN t1.Amount ELSE 0 END)OPDOther, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID =1 AND UPPER(IFNULL(MainConsultant,''))<> UPPER(IFNULL(OnConsultant,'')) THEN t1.Amount ELSE 0 END)IPD_CrossConsultation, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID =1 AND UPPER(IFNULL(MainConsultant,''))= UPPER(IFNULL(OnConsultant,'')) THEN t1.Amount ELSE 0 END)IPD_Consultation, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID =3 THEN t1.Amount ELSE 0 END)IPDInvestigation, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID =25 THEN t1.Amount ELSE 0 END)IPDMinorProcedure, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID =22 THEN t1.Amount ELSE 0 END)IPDSurgery, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID =14 THEN t1.Amount ELSE 0 END)IPDPackage, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID =2 THEN t1.Amount ELSE 0 END)IPDRoom, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID NOT IN (1,2,3,14,22,25) and ucase(DisplayName)='MEDICINE & CONSUMABLES' THEN t1.Amount ELSE 0 END)IPDMedCons, " +
        "    (CASE WHEN BillType='IPD' AND ConfigID NOT IN (1,2,3,14,22,25) and ucase(DisplayName)<>'MEDICINE & CONSUMABLES' THEN t1.Amount ELSE 0 END)IPDOther, " +
        "    Displayname,IF(IFNULL(oDoctorID,'')='',mDoctorID,oDoctorID)DoctorID FROM ( " +
        "        SELECT dm.Name MainConsultant,dm.Name OnConsultant,t.Amount,ConfigID,Displayname, " +
        "        SubCategory,BillType,pmh.DoctorID oDoctorID,pmh.DoctorID mDoctorID FROM ( " +
        "               SELECT lt.TransactionID,ltd.Amount,lt.TypeOfTnx,cf.ConfigID,sc.Displayname, " +
        "               sc.Name SubCategory,'OPD' BillType " +
        "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  " +
        "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID =ltd.SubCategoryID  " +
        "               INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID " +
        "               WHERE DATE(lt.date)>='" + ucFromDate.GetDateForDataBase() + "' AND DATE(lt.date)<='" + ucToDate.GetDateForDataBase() + "'  " +
        "               AND lt.TypeOfTnx IN ('opd-appointment','opd-lab','opd-procedure','opd-other','opd-package','CASUALTY-BILLING') AND lt.Iscancel=0 " +
        "        )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID " +
        "        INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID " +
        "        UNION ALL " +
        "        SELECT dm.Name MainConsultant,dms.Name OnConsultant,t.Amount,ConfigID,Displayname, " +
        "        SubCategory,BillType,t.DoctorID ODoctorID,pmh.DoctorID mDoctorID FROM ( " +
        "               SELECT lt.TransactionID,ltd.Amount, " +
        "               IF(ltd.IsSurgery=0,ltd.DoctorID,(SELECT DoctorID FROM f_surgery_doctor WHERE " +
        "               SurgeryTransactionID=(SELECT SurgeryTransactionID FROM f_surgery_discription WHERE " +
        "               ledgertransactionNo = ltd.ledgertransactionNo AND ItemID = ltd.ItemID)))DoctorID, " +
        "               lt.LedgerTransactionNo ,lt.TypeOfTnx,cf.ConfigID,sc.Displayname, " +
        "               sc.Name SubCategory,'IPD' BillType " +
        "               FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo " +
        "               INNER JOIN f_Itemmaster im ON im.ItemID = ltd.ItemID " +
        "               INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID =ltd.SubCategoryID " +
        "               INNER JOIN f_configrelation cf ON cf.CategoryID= sc.CategoryID " +
        "               WHERE DATE(lt.BillDate)>='" + ucFromDate.GetDateForDataBase() + "' AND DATE(lt.BillDate)<='" + ucToDate.GetDateForDataBase() + "' " +
        "               AND ltd.IsVerified=1 AND ltd.isPackage=0 " +
        "               AND IF(DATE(lt.BillDate) <= '2012-01-02',1,IF(IFNULL(im.Type_ID,'')='HS',IFNULL(im.ServiceItemID,'')<>'',IFNULL(im.Type_ID,'')<>'HS')) " +
        "        )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID " +
        "        INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID " +
        "        INNER JOIN f_ipdadjustment adj ON adj.TransactionID = pmh.TransactionID " +
        "        LEFT JOIN doctor_master dmS ON dms.DoctorID = t.DoctorID " +
        "    )t1 " +
        ")t2  ";

        if (ddlDoctor.SelectedValue != "ALL")
            str += " where t2.DoctorID='" + ddlDoctor.SelectedValue + "' ";

        str += "GROUP BY Consultant ORDER BY Consultant";

        dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            

            DataRow Newdr = dt.NewRow();
            for(int iCtr=0;iCtr<dt.Columns.Count;iCtr++)
            {
                if (iCtr == 0)
                {
                    Newdr[iCtr] = "TOTAL : ";
                }
                
                if (iCtr > 0)
                {
                    Newdr[iCtr] = dt.Compute("sum(" + dt.Columns[iCtr] + ")", "");
                }
            }

            dt.Rows.Add(Newdr);
            return dt;
        }
        else
        {            
            return null;
        }
    
    }

    //protected void grdDetail_RowCreated(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.Header)
    //    {
    //        GridView oGridView = (GridView)sender;
    //        GridViewRow oGridViewRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

    //        oGridViewRow.HorizontalAlign = HorizontalAlign.Center;
    //        TableCell oTableCell = new TableCell();

    //        oTableCell = new TableCell();
    //        oTableCell.Text = "S.No.";
    //        oTableCell.CssClass = "GridViewHeaderStyle";
    //        oTableCell.Width = Unit.Pixel(30);
    //        oGridViewRow.Cells.Add(oTableCell);

    //        oTableCell = new TableCell();
    //        oTableCell.Text = "Doctor Name";
    //        oTableCell.CssClass = "GridViewHeaderStyle";
    //        oTableCell.Width = Unit.Pixel(180);
    //        oGridViewRow.Cells.Add(oTableCell);

    //        oTableCell = new TableCell();
    //        oTableCell.Text = "<table width='100%'>" +
    //                                       "<tr>" +
    //                                            "<td align='center' colspan = '7' class='GridViewHeaderStyle'>OPD</td>" +
    //                                       "</tr>" +
    //                                       "<tr>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Consult</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Casualty</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Invest</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Proc</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Pkg</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Others</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Total</td>" +
    //                                       "</tr>" +
    //                                   "</table>";
    //        oTableCell.CssClass = "GridViewHeaderStyle";
    //        oTableCell.ColumnSpan = 7;
    //        oTableCell.Width = Unit.Pixel(700);
    //        oGridViewRow.Cells.Add(oTableCell);

    //        oTableCell = new TableCell();
    //        oTableCell.Text = "<table width='100%'>" +
    //                                       "<tr>" +
    //                                            "<td align='center' colspan = '8' class='GridViewHeaderStyle'>IPD</td>" +
    //                                       "</tr>" +
    //                                       "<tr>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Visits</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Cross-Con</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Invest</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >MinorPro</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Surgery</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Pkg</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Others</td>" +
    //                                            "<td class='GridViewHeaderStyle' width='100px' >Total</td>" +
    //                                       "</tr>" +
    //                                   "</table>";
    //        oTableCell.CssClass = "GridViewHeaderStyle";
    //        oTableCell.ColumnSpan = 8;
    //        oTableCell.Width = Unit.Pixel(800);
    //        oGridViewRow.Cells.Add(oTableCell);

    //        oTableCell = new TableCell();
    //        oTableCell.Text = "Total";
    //        oTableCell.CssClass = "GridViewHeaderStyle";
    //        oTableCell.Width = Unit.Pixel(100);
    //        oGridViewRow.Cells.Add(oTableCell);

    //        oGridView.Controls[0].Controls.AddAt(0, oGridViewRow);
    //        //oGridView.Controls[0].Controls.RemoveAt(1);

    //    }
    //}
    protected void grdDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void btnExport_Click(object sender, EventArgs e)
    {        
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=DoctorRevenue.xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        grdDetail.RenderControl(HtmlTextWriter);
        Response.Write(StringWriter.ToString());
        Response.End();        
    }
    protected void btnOpenOffice_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=DoctorRevenue.ods");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        grdDetail.RenderControl(HtmlTextWriter);
        Response.Write(StringWriter.ToString());
        Response.End();
        
    }
}
