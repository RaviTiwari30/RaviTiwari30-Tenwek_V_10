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

public partial class Reports_IPD_RevenueReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindCategory();
            BindGroups();
            ddlGroups_SelectedIndexChanged(sender, e);
            BindDoctor();
            //BindDept();
            All_LoadData.bindDocTypeList(ddlDepartment, 5, "Select");
            BindWard();
        }
    }

    private void BindDoctor()
    {
        string str = "";

        str = "SELECT DoctorID,NAME FROM doctor_master WHERE isactive=1 ORDER BY NAME ";        

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dt;
            ddlDoctor.DataTextField = "Name";
            ddlDoctor.DataValueField = "DoctorID";
            ddlDoctor.DataBind();
            ListItem li = new ListItem("ALL", "ALL");
            ddlDoctor.Items.Add(li);
            ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByText("ALL"));
            lblMsg.Text = "";

        }
        else
        {
            ddlDoctor.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }

    private void BindWard()
    {
        string str = "";

        str = "SELECT IpdCaseType_ID,NAME FROM ipd_case_type_master WHERE IsActive=1 ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlWard.DataSource = dt;
            ddlWard.DataTextField = "Name";
            ddlWard.DataValueField = "IpdCaseType_ID";
            ddlWard.DataBind();
            ListItem li = new ListItem("ALL", "ALL");
            ddlWard.Items.Add(li);
            ddlWard.SelectedIndex = ddlWard.Items.IndexOf(ddlWard.Items.FindByText("ALL"));
            lblMsg.Text = "";

        }
        else
        {
            ddlWard.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }

    public void BindDept()
    {
        string str = "";

        str = "SELECT categoryID,NAME FROM f_categorymaster WHERE Active=1 ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "categoryID";
            ddlCategory.DataBind();
            ListItem li = new ListItem("ALL", "ALL");
            ddlCategory.Items.Add(li);
            ddlCategory.SelectedIndex = ddlCategory.Items.IndexOf(ddlCategory.Items.FindByText("ALL"));
            lblMsg.Text = "";

        }
        else
        {
            ddlCategory.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }

    private void BindCategory()
    {
        string str = "";

        str = "Select cm.Name,cm.CategoryID from f_categorymaster cm inner join f_ConfigRelation cf on cf.CategoryID = cm.CategoryID where cm.Active=1 ";
    //    str += "and ConfigID in  (1,2,3,4,5,6,7,9,10,11,14,20,22,24,25,27,28,23) ";
        str += "and ConfigID in  (1,2,3,4,5,6,7,9,10,14,20,22,24,25,27,28,23) ";
        str += "order by Name";


        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ListItem li = new ListItem("ALL", "ALL");
            ddlCategory.Items.Add(li);
            ddlCategory.SelectedIndex = ddlCategory.Items.IndexOf(ddlCategory.Items.FindByText("ALL"));
            lblMsg.Text = "";

        }
        else
        {
            ddlCategory.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }

    private void BindGroups()
    {
        string str = "";

        str = "Select cm.Name,cm.CategoryID from f_categorymaster cm inner join f_ConfigRelation cf on cf.CategoryID = cm.CategoryID where cm.Active=1 ";
        

        if (ddlCategory.Visible == true)
        {
            if (ddlCategory.SelectedItem.Text != "ALL")
                str = str + " and cm.CategoryID  ='" + ddlCategory.SelectedValue + "' ";
            else
              //  str = str + " and cm.CategoryID in (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,11,14,20,22,24,25,27,28,23))";
                str = str + " and cm.CategoryID in (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,14,20,22,24,25,27,28,23))";
        }
        else
           // str += "and ConfigID in  (1,2,3,4,5,6,7,9,10,11,14,20,22,24,25,27,28,23) ";
        str += "and ConfigID in  (1,2,3,4,5,6,7,9,10,14,20,22,24,25,27,28,23) ";

        str += "order by Name";


        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlGroups.DataSource = dt;
            ddlGroups.DataTextField = "Name";
            ddlGroups.DataValueField = "CategoryID";
            ddlGroups.DataBind();
            ListItem li = new ListItem("ALL", "ALL");
            ddlGroups.Items.Add(li);
            ddlGroups.SelectedIndex = ddlGroups.Items.IndexOf(ddlGroups.Items.FindByText("ALL"));
            lblMsg.Text = "";

            if (ddlCategory.Visible == true)
            {
                BindSubGroups();
            }

        }
        else
        {
            ddlGroups.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }
    private void BindSubGroups()
    {
        string str = "select SubCategoryID,Name from f_subcategorymaster where CategoryID ";
        if (ddlGroups.SelectedItem.Text == "ALL")
        {
            if (ddlCategory.Visible == true)
            {
                if(ddlCategory.SelectedValue!="ALL")
                    str = str + "  ='" + ddlCategory.SelectedValue + "' ";
                else
                   // str = str + " in (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,11,14,20,22,24,25,27,28,23))";
                str = str + " in (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,14,20,22,24,25,27,28,23))";
            }
            else
               // str = str + " in (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,11,14,20,22,24,25,27,28,23))";
            str = str + " in (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,14,20,22,24,25,27,28,23))";
        }
        else
        {
            str = str + "  ='" + ddlGroups.SelectedValue + "' ";
        }

        
        
        
        str += " order by name ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            chlSubGroups.DataSource = dt;
            chlSubGroups.DataTextField = "Name";
            chlSubGroups.DataValueField = "SubCategoryID";
            chlSubGroups.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            chlSubGroups.Items.Clear();
            lblMsg.Text = "No Sub-Groups Found";
        }

    }
    protected void ddlGroups_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubGroups();        
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (chkOPDIPD.Items[0].Selected == false && chkOPDIPD.Items[1].Selected == false)
        {
            lblMsg.Text = "Kindly Select either OPD or IPD Data Type";
            return;
        }

        string subCatID="";

        foreach(ListItem li in chlSubGroups.Items)
        {
            if(li.Selected)
            {
                if (subCatID == "")
                    subCatID = "'" + li.Value + "'";
                else
                    subCatID = subCatID+",'" + li.Value + "'";
            }
        }

        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        string strBooked = "";
       
        #region Revenue Generated
        // ******************************* REVENUE GENERATED ********************************          
        if (rdoReportType.SelectedValue == "2")
        {
            if (rbtViewType.SelectedValue == "1")//Summarised Report
            {
                if (rbtnWise.SelectedValue != "3")
                {
                    strBooked = @"SELECT GroupName,SubGroup,ROUND((OPDCASHQty),3)OPDCASHQty,ROUND((OPDCASHAmt),3)OPDCASHAmt,ROUND((OPDCreditQty),3)OPDCreditQty,
                        ROUND((OPDCreditAmt),3)OPDCreditAmt,ROUND((IPDQty),3)IPDQty,ROUND((IPDAmt),3)IPDAmt,department,IPDCaseType_ID,WardName,DoctorID,
                        (SELECT NAME FROM doctor_master WHERE DoctorID=t7.DoctorID)DocName 
                         FROM ( ";

                    if (chkOPDIPD.Items[1].Selected) // OPD
                    {
                        if (rbtnWise.SelectedValue != "3")
                        {
                            strBooked += @"SELECT GroupName,SubGroup,ROUND((CASHQty),3)OPDCASHQty,ROUND((CASHAmt),3)OPDCASHAmt,ROUND((CreditQty),3)OPDCreditQty,
	                            ROUND((CreditAmt),3)OPDCreditAmt,0 IPDQty,0 IPDAmt,(SELECT Specialization FROM doctor_master WHERE DoctorID=t.DoctorID ";
                            if (rbtnWise.SelectedValue == "2")
                            {
                                if (ddlDepartment.SelectedIndex > 0)
                                    strBooked += " AND DocDepartmentID='" + ddlDepartment.SelectedValue + "' ";
                            }
                       strBooked +=@" )department, ''IPDCaseType_ID,''WardName,t.DoctorID  FROM (     
		                        SELECT (SELECT sc.NAME FROM f_subcategorymaster sc WHERE sc.SubcategoryID=ltd.SubCategoryID)SubGroup,
                               (SELECT cm.name FROM f_categorymaster cm INNER JOIN f_subcategorymaster sc ON sc.categoryID = cm.categoryID WHERE sc.subcategoryID = ltd.SubCategoryID LIMIT 1)GroupName,		
		                        (CASE WHEN lt.PanelID=1 THEN ROUND(ltd.Amount,3) WHEN lt.PanelID <> 1 AND rt.Date IS NOT NULL AND rt.Date=DATE(lt.Date) THEN ROUND(ltd.Amount,3) ELSE 0 END)CASHAmt,
		                        (CASE WHEN lt.PanelID=1 THEN ltd.Quantity WHEN lt.PanelID <> 1 AND rt.Date IS NOT NULL AND rt.Date=DATE(lt.Date) THEN ltd.Quantity ELSE 0 END)CASHQty,   		                           
		                        (CASE WHEN lt.PanelID <> 1 AND IFNULL(rt.Date,'')<>DATE(lt.Date) THEN ROUND(ltd.Amount,3) ELSE 0 END)CreditAmt,
                                (CASE WHEN lt.PanelID <> 1 AND rt.Date IS NULL THEN ltd.Quantity WHEN lt.PanelID <> 1 AND IFNULL(rt.Date,'')<>DATE(lt.Date) THEN ltd.Quantity ELSE 0 END)CreditQty,
		                        ltd.subcategoryID,ltd.DoctorID  
		                        FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON     lt.LedgerTransactionNo = ltd.LedgerTransactionNo
		                        INNER JOIN patient_medical_history pmh     ON pmh.TransactionID = lt.TransactionID 		                       
		                        LEFT JOIN f_reciept rt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo AND rt.Iscancel=0  WHERE lt.IsCancel=0 AND pmh.Type <> 'IPD' 
		                        AND DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'     AND DATE(lt.Date) <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ";

                            if (subCatID != "")
                                strBooked += " AND ltd.SubCategoryID in (" + subCatID + ") ";

                            if (rbtnWise.SelectedValue == "4")
                            {
                                if (ddlDoctor.SelectedValue != "ALL")
                                    strBooked += " AND sc.CategoryID='" + ddlCategory.SelectedValue + "' ";
                            }
                            strBooked += "   )t  ";
                            //if (rbtnWise.SelectedValue == "2")
                            //{
                            //    if (ddlDepartment.SelectedIndex > 0)
                            //        strBooked += " AND dh.Department='" + ddlDepartment.SelectedValue + "' ";
                            //}
                            if (rbtnWise.SelectedValue == "1")
                            {
                                if (ddlDoctor.SelectedValue != "ALL")
                                    strBooked += " where t.DoctorID='" + ddlDoctor.SelectedValue + "' ";
                            }
                            
                        }
                    }

                    if (chkOPDIPD.Items[0].Selected) // IPD
                    {
                        if (chkOPDIPD.Items[1].Selected)  // checking if OPD is selected
                        {
                            if (rbtnWise.SelectedValue != "3")
                                strBooked += " UNION ALL ";
                        }

                        strBooked += @"  SELECT GroupName, SubGroup,0 OPDCASHQty,0 OPDCASHAmt,0 OPDCreditQty,0 OPDCreditAmt,ROUND(Quantity,3)IPDQty,ROUND(ItemNetAmt,3)IPDAmt,	                           
	                            dm.Specialization Department,	                            
	                           IPDCaseType_ID, IF(pip.IPDCaseType_ID<>'',(SELECT NAME FROM ipd_case_type_master icd WHERE icd.IPDCaseType_ID=pip.IPDCaseType_ID),'')WardName,docId DoctorID
	                              FROM (    
		                           SELECT (SELECT NAME FROM f_subcategorymaster WHERE subcategoryid=ltd.SubCategoryID)SubGroup,
			                            (SELECT cm.name FROM f_categorymaster cm INNER JOIN f_subcategorymaster sc ON sc.categoryID = cm.categoryID WHERE sc.subcategoryID = ltd.SubCategoryID LIMIT 1)Groupname,
                                         adj.TransactionID,ltd.Quantity,ROUND((ltd.Amount-(((ltd.Amount)*adj.TotalBillDiscPer)/100)),3)ItemNetAmt,ltd.DoctorID docId FROM f_ipdadjustment adj
                                          INNER JOIN f_ledgertnxdetail ltd ON adj.TransactionID= ltd.TransactionID
                                          WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ";
                        strBooked += "  AND (adj.BillNo IS NOT NULL OR adj.BillNo <>'') AND DATE(adj.BillDate) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' ";
                        strBooked += "  AND DATE(adj.BillDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ";
                       
                        if (rbtnWise.SelectedValue == "1")
                        {
                            if (ddlDoctor.SelectedValue != "ALL")
                                strBooked += " and ltd.DoctorID='" + ddlDoctor.SelectedValue + "' ";
                        }
                       

                        if (subCatID != "")
                            strBooked += "             AND ltd.SubCategoryID in (" + subCatID + ") ";

                        if (rbtnWise.SelectedValue == "4")
                        {
                            if (ddlDoctor.SelectedValue != "ALL")
                                strBooked += " AND sc.CategoryID='" + ddlCategory.SelectedValue + "' ";
                        }
                      		                            
	                    strBooked +=@"   )t6 INNER JOIN (SELECT IPDCaseType_ID,TransactionID FROM patient_ipd_profile WHERE PatientIPDProfile_ID IN 
	                            (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile GROUP BY TransactionID )) pip ON pip.TransactionID=t6.TransactionID 
	                             LEFT JOIN doctor_master dm ON dm.DoctorID = t6.docID  ";
                        if (rbtnWise.SelectedValue == "2")
                        {
                            if (ddlDepartment.SelectedIndex > 0)
                                strBooked += " AND dm.DocDepartmentID='" + ddlDepartment.SelectedValue + "' ";
                        }
     
                    }
                    strBooked += ")t7 ORDER BY SubGroup ";
                }
                else         // Ward Wise Summary report
                {
                    if (chkOPDIPD.Items[0].Selected) // IPD
                    {
                    strBooked = @"SELECT GroupName,SubGroup,ROUND((OPDCASHQty),3)OPDCASHQty,ROUND((OPDCASHAmt),3)OPDCASHAmt,ROUND((OPDCreditQty),3)OPDCreditQty,ROUND((OPDCreditAmt),3)OPDCreditAmt,
                        ROUND((IPDQty),3)IPDQty,ROUND((IPDAmt),3)IPDAmt,                    
                        DoctorID,Department,IPDCaseType_ID,WardName
                         FROM ( ";
                    strBooked += @"  SELECT GroupName, SubGroup,0 OPDCASHQty,0 OPDCASHAmt,0 OPDCreditQty,0 OPDCreditAmt,round(Quantity,3)IPDQty,round(ItemNetAmt,3)IPDAmt,                            
	                            docId DoctorID, dm.Specialization Department,pip.IPDCaseType_ID,IF(pip.IPDCaseType_ID<>'',(SELECT NAME FROM ipd_case_type_master icd WHERE icd.IPDCaseType_ID=pip.IPDCaseType_ID),'')WardName
	                              FROM (    
		                            SELECT (SELECT NAME FROM f_subcategorymaster WHERE subcategoryid=ltd.SubCategoryID)SubGroup,
			                           (SELECT cm.name FROM f_categorymaster cm INNER JOIN f_subcategorymaster sc ON sc.categoryID = cm.categoryID          
				                           WHERE sc.subcategoryID = ltd.SubCategoryID LIMIT 1)Groupname,              
					                       adj.TransactionID,ltd.Quantity,ROUND(ltd.Amount,3)ItemNetAmt,ltd.DoctorID docId 
					                       FROM f_ipdadjustment adj INNER JOIN f_ledgertnxdetail ltd ON adj.TransactionID= ltd.TransactionID						                            
						                   WHERE ltd.IsVerified=1 AND ltd.IsPackage=0  ";
                        strBooked += "  AND (adj.BillNo IS NOT NULL OR adj.BillNo <>'') AND DATE(adj.BillDate) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' ";
                        strBooked += "  AND DATE(adj.BillDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'   ";
                        if (subCatID != "")
                            strBooked += "   AND ltd.SubCategoryID in (" + subCatID + ") ";
                      
                    if (ddlWard.SelectedValue!="ALL")
                           strBooked += @" AND IPDCaseType_ID='" + ddlWard.SelectedValue + "'  ";
                   
                        if (rbtnWise.SelectedValue == "1")
                        {
                            if (ddlDoctor.SelectedValue != "ALL")
                                strBooked += " and ltd.DoctorID='" + ddlDoctor.SelectedValue + "' ";
                        }
                        strBooked += @"   )t6 INNER JOIN (SELECT IPDCaseType_ID,TransactionID FROM patient_ipd_profile WHERE PatientIPDProfile_ID IN 
	                            (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile GROUP BY TransactionID )) pip ON pip.TransactionID=t6.TransactionID 
	                             LEFT JOIN doctor_master dm ON dm.DoctorID = t6.docID  ";
                        if (rbtnWise.SelectedValue == "2")
                        {
                            if (ddlDepartment.SelectedIndex > 0)
                                strBooked += " AND dm.DocDepartmentID='" + ddlDepartment.SelectedValue + "' ";
                        }
                        if (rbtnWise.SelectedValue == "2")
                        {
                            if (ddlDepartment.SelectedIndex > 0)
                                strBooked += " AND dm.DocDepartmentID='" + ddlDepartment.SelectedValue + "' ";
                        }                                          
                    strBooked += ")t7 ORDER BY SubGroup ";
                }
                }
                dt = StockReports.GetDataTable(strBooked.ToString());
           
            }

    
        }
        #endregion Revenue Generated
        

        if (dt != null && dt.Rows.Count > 0)
        {
            string ReportWise = "";

            if (rbtnWise.SelectedValue == "1")
                ReportWise = "DoctorWise";
            else if (rbtnWise.SelectedValue == "2")
                ReportWise = "DepartmentWise";
            else if (rbtnWise.SelectedValue == "3")
                ReportWise = "WardWise";
            else if (rbtnWise.SelectedValue == "4")
                ReportWise = "CategoryWise";

            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
            dt.Columns.Add(dc);


            dc = new DataColumn();
            dc.ColumnName = "ReportType";
            dc.DefaultValue = rdoReportType.SelectedItem.Text + " (" + rbtViewType.SelectedItem.Text + ") " + ReportWise;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "ReportWise";
            dc.DefaultValue = ReportWise;
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            //if(rbtViewType.SelectedValue=="1")
            //ds.WriteXmlSchema(@"c:\itdosetemp\AnandRevenueSum.xml");
            //else
            //ds.WriteXmlSchema(@"c:\AnandRevenueSumBkup.xml");

            Session["ds"] = ds;

            if (rbtViewType.SelectedValue == "1")
                Session["ReportName"] = "RevenueSummary";
            else
                Session["ReportName"] = "RevenueSummaryBreakup";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/CommonCrystalReportViewer.aspx');", true);
        }
        else
            lblMsg.Text = "No record found";
    }
    protected void chkSubGroups_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chlSubGroups.Items.Count; i++)
            chlSubGroups.Items[i].Selected = chkSubGroups.Checked;
    }
    protected void rbtnWise_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnWise.SelectedValue == "1")
        {
            lblTypeName.Text = "Doctor Name ";
            ddlDoctor.Visible = true;
            ddlDepartment.Visible = false;
            ddlWard.Visible = false;
            ddlCategory.Visible = false;
        }
        else if (rbtnWise.SelectedValue == "2")
        {
            lblTypeName.Text = "Department Name ";
            ddlDepartment.Visible = true;
            ddlDoctor.Visible = false;
            ddlWard.Visible = false;
            ddlCategory.Visible = false;
        }
        else if (rbtnWise.SelectedValue == "3")
        {
            lblTypeName.Text = "Ward Name ";
            ddlWard.Visible = true;
            ddlDoctor.Visible = false;
            ddlDepartment.Visible = false;
            ddlCategory.Visible = false;
        }
        else if (rbtnWise.SelectedValue == "4")
        {
            lblTypeName.Text = "Category Name ";
            ddlCategory.Visible = true;
            ddlDoctor.Visible = false;
            ddlDepartment.Visible = false;
            ddlWard.Visible = false;
            BindGroups();
        }
    }
    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroups();
    }
}
