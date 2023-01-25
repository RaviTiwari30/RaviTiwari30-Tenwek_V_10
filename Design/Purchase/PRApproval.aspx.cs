using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Purchase_PRApproval : System.Web.UI.Page
{
    DataTable dtItemDetails = new DataTable();

    #region Event Handling

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindLedger(Session["ID"].ToString());
            if (ChkRights())
            {
                string Msg = "You do not have rights to Approve purchase Request ";
                Response.Redirect("MsgPage.aspx?msg=" + Msg);
            }
            if (Session["DeptLedgerNo"] != null)
                ViewState["CurDeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            else
                ViewState["CurDeptLedgerNo"] = "";
            ViewState["CentreID"] = Session["CentreID"].ToString();
            BindDepartment();
            BindPurchaseGrid();
        }
    }
    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rdbLedMas.Items[0].Enabled = false;
        rdbLedMas.Items[1].Enabled = false;

        DataTable dt1 = StockReports.GetPurchaseApproval("PR", EmpId);
        if (dt1 != null && dt1.Rows.Count > 0)
        {
            DataTable dt = StockReports.GetRights(RoleId);
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
                {
                    string Msg = "You do not have rights to Approve purchase Request ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                }
                else
                {
                    if (Util.GetBoolean(dt.Rows[0]["IsGeneral"]) == true && Util.GetBoolean(dt.Rows[0]["IsMedical"]) == true)
                    {
                        rdbLedMas.Items[0].Enabled = true;
                        rdbLedMas.Items[1].Enabled = true;
                        rdbLedMas.SelectedIndex = 0;
                    }
                    else if (Util.GetBoolean(dt.Rows[0]["IsMedical"]) == true)
                    {
                        rdbLedMas.Items[0].Enabled = false;
                        rdbLedMas.SelectedIndex = rdbLedMas.Items.IndexOf(rdbLedMas.Items.FindByValue("STO00001"));
                    }
                    else if (Util.GetBoolean(dt.Rows[0]["IsGeneral"]) == true)
                    {
                        rdbLedMas.Items[1].Enabled = false;
                        rdbLedMas.SelectedIndex = rdbLedMas.Items.IndexOf(rdbLedMas.Items.FindByValue("STO00002"));
                    }
                    return false;
                }
                return false;
            }
            else { return true; }
        }
        else { return true; }
    }

    protected void rdbLedMas_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPurchaseGrid();
    }

    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (GridView1.Rows.Count > 0)
        {
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                ((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked = CheckBox1.Checked;
            }
        }
    }

    protected void btnItem_Click(object sender, EventArgs e)
    {
        string prno = GetPRNO();
        if (prno != string.Empty)
            GetSelectedItems(prno);
        else
        {
            grdItemDetails.DataSource = null;
            grdItemDetails.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM247','" + lblmsg.ClientID + "');", true);
        }
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            txtCancelReason.Text = "";
            int Index = Util.GetInt(e.CommandArgument);
            lblPRNo2.Text = GridView1.Rows[Index].Cells[2].Text;
            mpCancel.Show();
        }
    }
    protected void grdItemDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            DataTable dtItem = new DataTable();
            int index = Util.GetInt(e.CommandArgument);
            string PRDetailID = ((Label)grdItemDetails.Rows[index].FindControl("lblReqDetailID")).Text;
            ViewState.Add("PRDetailID", PRDetailID);
            string strQuery = string.Empty;
            strQuery = "select PRD.PurchaseRequisitionNo,PRD.ItemID,PRD.ItemName,PRD.RequestedQty,PRD.ApprovedQty,PRD.ApproxRate,prd.Discount,PRD.ProbableVendorID,PRD.Specification,PRD.InHandQty,LM.LedgerName from f_purchaserequestdetails PRD left   join f_ledgermaster LM on LM.LedgerNumber=PRD.ProbableVendorID and GroupID='PHY' where  PRD.PuschaseRequistionDetailID=" + PRDetailID + "";
            dtItem = StockReports.GetDataTable(strQuery);
            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                lblPRNO.Text = Util.GetString(dtItem.Rows[0]["PurchaseRequisitionNo"]);
                lblItemName.Text = Util.GetString(dtItem.Rows[0]["ItemName"]);
                lblRQty.Text = Util.GetString(dtItem.Rows[0]["RequestedQty"]);
                lblInitQty.Text = Util.GetString(dtItem.Rows[0]["InHandQty"]);
                txtApproveQty.Text = Util.GetString(dtItem.Rows[0]["ApprovedQty"]);

            }


            mpeCreateGroup.Show();

        }

        if (e.CommandName == "Reject")
        {
            int index = Util.GetInt(e.CommandArgument);
            lblPRNO1.Text = ((Label)grdItemDetails.Rows[index].FindControl("lblReqDetailID")).Text;
            lblitemid.Text = ((Label)grdItemDetails.Rows[index].FindControl("lblItemID")).Text;
            lblItemName1.Text = ((Label)grdItemDetails.Rows[index].FindControl("lblItemName")).Text;
            lblreqno.Text = ((Label)grdItemDetails.Rows[index].FindControl("lblPurchaseRequisitionNo")).Text;
            mapItemCancel.Show();
        }
        if (e.CommandName == "AView")
        {
            string ItemID = e.CommandArgument.ToString().Split('$')[0];
            string ItemName = e.CommandArgument.ToString().Split('$')[1];
            lblPopupItem.Text = "Item Name : " + ItemName;
            StringBuilder sb = new StringBuilder();

            sb.Append(" select st.inhand,st.DeptLedgerNo, ROUND(((IFNULL(sd.issue,0)-IFNULL(sd.ret,0))/2)) AvgCon ,");
            sb.Append(" im.ItemID,st.itemname,lm.LedgerName");
            sb.Append(" from (select ROUND(IF(ISPOST=1,SUM(InitialCount-ReleasedCount),0),2)inhand,ItemID,DeptLedgerNo,ItemName from ");
            sb.Append(" f_stock where ItemID='" + ItemID + "' and StoreLedgerNo='" + ViewState["LedgerNumber"].ToString() + "' AND CentreID='" + ViewState["CentreID"].ToString() + "' group by DeptLedgerNo,ItemID ");
            sb.Append(" ) st INNER JOIN f_itemmaster im on im.ItemID=st.itemid ");
            sb.Append(" INNER JOIN f_ledgermaster lm on lm.LedgerNumber=st.DeptLedgerNo");
            sb.Append(" LEFT OUTER join ");
            sb.Append(" (select sum(if(TrasactionTypeID IN(5,14),SoldUnits,0)) ret,");
            sb.Append(" sum(if(TrasactionTypeID IN(3,13),SoldUnits,0)) issue,DeptLedgerNo,ItemID from f_salesdetails where");
            sb.Append(" DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND ItemID='" + ItemID + "' AND CentreID='" + ViewState["CentreID"].ToString() + "' and ");
            sb.Append(" TrasactionTypeID IN(5,14,3,13) group by DeptLedgerNo,ItemID ) sd on sd.itemid=st.itemid and sd.DeptLedgerNo=st.DeptLedgerNo");


            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdItem.DataSource = dt;
                grdItem.DataBind();
                mdlView.Show();
            }
            else
            {
                grdItem.DataSource = null;
                grdItem.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM053','" + lblmsg.ClientID + "');", true);
            }
        }
    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string strQuery = "", PRDetailID = "";
        if (ViewState["PRDetailID"] != null)
        {
            PRDetailID = ViewState["PRDetailID"].ToString();
            strQuery = "update f_purchaserequestdetails set ApprovedQty=" + txtApproveQty.Text + ",LastUpdatedBy='" + ViewState["UserID"].ToString() + "',UpdateDate=NOW(),IPAddress='" + Request.UserHostAddress + "' where PuschaseRequistionDetailID=" + PRDetailID + "";

            int Result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
            if (Result >= 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                GetSelectedItems(GetPRNO());
            }
            else
            {
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            }
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ValidateGrid())
        {
            MySqlConnection conn;
            MySqlTransaction tnx;
            conn = Util.GetMySqlCon();
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }
            tnx = conn.BeginTransaction();
            try
            {

                string PRNO = string.Empty, IsLast = string.Empty, PAEmpId = string.Empty, EMPID = string.Empty;
                string EMPName = string.Empty, LedgerNumber = string.Empty, value = string.Empty;
                string PRNOs = string.Empty;
                string ItemIDs = string.Empty;
                bool Result = false;
                value = "aaa";
                EMPID = Convert.ToString(Session["ID"]);
                EMPName = Convert.ToString(Session["UserName"]);
                if (ViewState["LedgerNumber"] != null)
                {
                    LedgerNumber = ViewState["LedgerNumber"].ToString();

                    if (rdbPRApproval.SelectedItem.Value == "Approve")
                    {
                        for (int i = 0; i < GridView1.Rows.Count; i++)
                        {
                            if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked)
                            {
                                if (PRNOs == "")
                                {
                                    PRNOs = "'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                                }
                                else
                                {
                                    PRNOs = PRNOs + "," + "'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                                }
                            }
                        }

                            string strnew = " SELECT ItemID,PurchaseRequisitionNo FROM f_purchaserequestdetails WHERE PurchaseRequisitionNo IN (" + PRNOs + ") ";
                            DataTable dtnew = StockReports.GetDataTable(strnew);
                            PRNOs = "";
                            foreach (DataRow dr in dtnew.Rows)
                            {
                                if (ItemIDs == "")
                                {
                                    string strcheck = " SELECT IFNULL(Quote_ID,'')Quote_ID FROM AutopoQuotation WHERE ItemId='" + dr["ItemID"].ToString() + "'  AND DATE(dateupto)>=CURDATE() and isactive=1 ORDER BY Quote_ID DESC LIMIT 1  ";
                                    string QuoteID = Util.GetString(MySqlHelper.ExecuteScalar(conn, CommandType.Text, strcheck));
                                    if (QuoteID != "")
                                    {
                                        PRNOs = "'" + dr["PurchaseRequisitionNo"].ToString() + "'";
                                        ItemIDs = "'" + dr["ItemID"].ToString() + "'";
                                    }
                                }
                                else
                                {
                                    string strcheck = " SELECT IFNULL(Quote_ID,'')Quote_ID FROM AutopoQuotation WHERE ItemId='" + dr["ItemID"].ToString() + "'  AND DATE(dateupto)>=CURDATE()  and isactive=1  ORDER BY Quote_ID DESC LIMIT 1  ";
                                    string QuoteID = Util.GetString(MySqlHelper.ExecuteScalar(conn, CommandType.Text, strcheck));
                                    if (QuoteID != "")
                                    {
                                        PRNOs = PRNOs + "," + "'" + dr["PurchaseRequisitionNo"].ToString() + "'";
                                        ItemIDs = ItemIDs + "," + "'" + dr["ItemID"].ToString() + "'";
                                    }
                                }
                            }
                            if (PRNOs != string.Empty)
                            {
                                GetSelectedItemsNew(PRNOs, ItemIDs);
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM248','" + lblMsgAuto.ClientID + "');", true);

                                mpeAutoPo.Show();
                                return;

                            } 

                    }

                    if (rdbPRApproval.SelectedItem.Value == "Approve")
                    {
                        for (int i = 0; i < GridView1.Rows.Count; i++)
                        {
                            if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked)
                            {
                                PRNO = "'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "call UpdatePurchaseReqApproval(" + PRNO + ",'" + EMPID + "','" + EMPName + "','" + value + "',1,0)");
                                if (result > 0)
                                {
                                    All_LoadData.updateNotification(((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text, "", Util.GetString(Session["RoleID"].ToString()), 24, null, "Store");
                                    Result = true;
                                }
                                else
                                {
                                    Result = false;
                                }
                            }
                        }
                    }

                    else
                    {
                        for (int i = 0; i < GridView1.Rows.Count; i++)
                        {
                            if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked == true)
                            {
                                PRNO = "'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "call UpdatePurchaseReqApproval(" + PRNO + ",'" + EMPID + "','" + EMPName + "','" + value + "',2,0)");
                                if (result > 0)
                                {
                                    All_LoadData.updateNotification(((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text, "", Util.GetString(Session["RoleID"].ToString()), 31, null, "Store");
                                    Result = true;
                                }
                                else
                                {
                                    Result = false;
                                }
                            }
                        }
                    }

                    if (Result == true)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                        tnx.Commit();
                        tnx.Dispose();
                        conn.Close();
                        conn.Dispose();
                        BindPRRequest(EMPID, LedgerNumber);
                        grdItemDetails.DataSource = null;
                        grdItemDetails.DataBind();

                    }
                    else
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
                }
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
                tnx.Rollback();
                tnx.Dispose();
                conn.Close();
                conn.Dispose();
            }
        }
    }
    protected void grdItemDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row != null)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string PrDetailID = ((Label)e.Row.FindControl("lblReqDetailID")).Text.Trim();

                DataTable dtTax = new DataTable();
                dtTax = BindTax(PrDetailID);

                if (dtTax.Rows.Count > 0)
                {
                    Repeater rpTax = (Repeater)e.Row.FindControl("rpTax");
                    rpTax.DataSource = dtTax;
                    rpTax.DataBind();
                }
            }
        }
    }

    #endregion

    #region Data Binding
    private void BindLedger(string EmpID)
    {
        string str = " SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE groupid='STO' ";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            rdbLedMas.DataSource = dt;
            rdbLedMas.DataTextField = "LedgerName";
            rdbLedMas.DataValueField = "LedgerNumber";
            rdbLedMas.DataBind();
        }
        else
        {
            lblmsg.Text = "You Are Not Authorized to Approve/Reject Purchase Request";
            divApproval.Visible = false;
            return;
        }
    }

    private void BindPRRequest(string EmpID, string LedgerNumber)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.PurchaseRequestNo,em.Name,pm.Subject,DATE_FORMAT(PM.RaisedDate, '%d-%b-%y') RaisedDate,IFNULL(lm.LedgerName,'')DepartMentName  ");
        sb.Append(" FROM f_purchaserequestmaster pm ");
        sb.Append(" INNER JOIN employee_master em ON pm.RaisedByID = em.EmployeeID LEFT JOIN f_ledgermaster lm ON lm.LedgerNumber=pm.IssuedTo AND lm.GroupID='DPT' ");
        sb.Append(" WHERE pm.storeid = '" + LedgerNumber + "' AND pm.Status='0' AND pm.CentreID='" + ViewState["CentreID"].ToString() + "' ");
        if (ddldepartment.SelectedItem.Value != "0")
        {
            sb.Append(" and  lm.LedgerNumber='" + ddldepartment.SelectedItem.Value.ToString() + "' ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
            ViewState.Add("PRNO", dt);
            btnSave.Enabled = true;
            btnItem.Enabled = true;
        }
        else
        {
            GridView1.DataSource = null;
            GridView1.DataBind();

            btnSave.Enabled = false;
            btnItem.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
    private string GetPRNO()
    {
        string PRNO = string.Empty;
        if (GridView1.Rows.Count > 0)
        {
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked == true)
                {
                    if (PRNO != string.Empty)
                        PRNO += ",'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                    else
                        PRNO += "'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                }
            }
        }
        return PRNO;
    }
    private void GetSelectedItems(string PRNO)
    {
        StringBuilder sb = new StringBuilder();
        if (ViewState["LedgerNumber"] != null)
        {
            sb.Append("  SELECT PuschaseRequistionDetailID,PurchaseRequisitionNo,ItemName,ItemID,RequestedQty,ApprovedQty, OrderedQty,Discount, ");
            sb.Append("  Specification,Purpose,ProbableVendorID,ApproxRate,InHandQty,LedgerName,ROUND((Issue-ReturnUnit)/2)AvgConsumption, ");
            sb.Append("  CurrentStock,POStock,DeptStock,MainStock,ReorderLevel,Indent_Department FROM ( ");
            sb.Append("     SELECT PuschaseRequistionDetailID,PurchaseRequisitionNo,ItemName,t1.ItemID,RequestedQty, ");
            sb.Append("     ApprovedQty, OrderedQty,IFNULL(t1.Discount,auto.discount)discount,t1.Specification,Purpose,ProbableVendorID,ROUND(IFNULL(ApproxRate,auto.Rate),2)ApproxRate,InHandQty, ");
            sb.Append("     (SELECT VendorName FROM f_vendormaster WHERE vendor_id=auto.VendorID)LedgerName,         ");
            sb.Append("     IFNULL(Issue,0)Issue,IFNULL(ReturnUnit,0)ReturnUnit,CurrentStock,POStock,DeptStock,MainStock,ReorderLevel,t1.Indent_Department  ");
            sb.Append("      FROM ( ");
            sb.Append("         SELECT prd.PuschaseRequistionDetailID,prd.PurchaseRequisitionNo,prd.ItemName,prd.ItemID, prd.RequestedQty, ");
            sb.Append("        prd.ApprovedQty,prd.OrderedQty,prd.Discount, prd.Specification, prd.Purpose,prd.ProbableVendorID,  ");
            sb.Append("        prd.ApproxRate,prd.InHandQty,(SELECT SUM(SoldUnits) FROM f_salesdetails  WHERE itemID=prd.itemID  ");
            sb.Append("         AND DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(3,13))Issue , ");
            sb.Append("         (SELECT SUM(SoldUnits) FROM f_salesdetails  WHERE itemID=prd.itemID AND DATE<=CURRENT_DATE AND  ");
            sb.Append("         DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(5,14))ReturnUnit ,ifnull((SELECT SUM(InitialCount-ReleasedCount)  ");
            sb.Append("         FROM f_stock st WHERE st.itemid=prd.ItemID AND ISPOST=1 AND CentreID='" + ViewState["CentreID"].ToString() + "' GROUP BY st.itemid),0)CurrentStock, ");

            sb.Append(" IFNULL((SELECT SUM(pod.ApprovedQty)ApprovedQty FROM f_purchaseorderdetails pod INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo=pod.PurchaseOrderNo  WHERE pod.ItemID=prd.ItemID AND pod.ApprovedQty>0 AND po.Status=2 AND pod.RecievedQty=0  GROUP BY pod.ItemID ),0)POStock, ");

            sb.Append("  IFNULL((SELECT ROUND(IF(st.ISPOST=1,SUM(st.InitialCount-st.ReleasedCount),0),2) FROM f_stock st  ");
            sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=st.DeptledgerNo WHERE   StoreLedgerNo='" + ViewState["LedgerNumber"].ToString() + "' AND CentreID='" + ViewState["CentreID"].ToString() + "' AND st.ItemID=prd.ItemID   ");
            sb.Append(" AND lm.LedgerNumber=(SELECT IssuedTo FROM f_purchaserequestmaster WHERE PurchaseRequestNo=prd.PurchaseRequisitionNo)  GROUP BY DeptLedgerNo,ITemID ),0)DeptStock,    ");

            sb.Append("  IFNULL((SELECT ROUND(IF(ISPOST=1,SUM(InitialCount-ReleasedCount),0),2)  FROM  ");
            sb.Append(" f_stock st INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=st.DeptLedgerNo ");
            sb.Append(" WHERE ItemID=prd.ItemID AND StoreLedgerNo='" + ViewState["LedgerNumber"].ToString() + "'  ");
            if (ViewState["LedgerNumber"].ToString() == "STO00001")
            {
                sb.Append("  AND lm.LedgerNumber='" + AllGlobalFunction.MedicalDeptLedgerNo.ToString() + "'  AND CentreID='" + ViewState["CentreID"].ToString() + "' GROUP BY DeptLedgerNo,ItemID),0)MainStock, ");
            }
            else
                sb.Append("  AND lm.LedgerNumber='" + AllGlobalFunction.GeneralDeptLedgerNo.ToString() + "'  AND CentreID='" + ViewState["CentreID"].ToString() + "' GROUP BY DeptLedgerNo,ItemID),0)MainStock, ");

            sb.Append("  IFNULL(ReorderLevel,0)ReorderLevel,prd.Indent_Department   FROM  f_purchaserequestdetails prd INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID LEFT JOIN  ");
            sb.Append("         f_ledgermaster lm ON  lm.LedgerNumber = prd.ProbableVendorID WHERE prd.PurchaseRequisitionNo  ");
            sb.Append("        IN (" + PRNO + ")   AND prd.Status <> 2 AND prd.CentreID='" + ViewState["CentreID"].ToString() + "' ORDER BY prd.PurchaseRequisitionNo, ");
            sb.Append("        prd.ItemName  ");
            sb.Append("        )t1 ");
            sb.Append("    LEFT JOIN AutopoQuotation auto ON auto.ItemID=t1.ItemID AND  DATE(DateUpto)>=CURDATE() AND isActive=1 	 ");
            sb.Append("    )t2 ");
        }
        dtItemDetails = StockReports.GetDataTable(sb.ToString());
        if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
        {
            grdItemDetails.DataSource = dtItemDetails;
            grdItemDetails.DataBind();
        }
        else
        {
            grdItemDetails.DataSource = null;
            grdItemDetails.DataBind();
        }
    }
    private void GetSelectedItemsNew(string PRNOs, string ItemIDs)
    {
        StringBuilder sb = new StringBuilder();
        if (ViewState["LedgerNumber"] != null)
        {
            sb.Append(" SELECT PuschaseRequistionDetailID,PurchaseRequisitionNo,ItemName,ItemID,RequestedQty,ApprovedQty, OrderedQty,Discount, ");
            sb.Append(" Specification,Purpose,ProbableVendorID,round(ApproxRate,2)ApproxRate,InHandQty,ROUND((Issue-ReturnUnit)/2)AvgConsumption,CurrentStock, ");
            sb.Append(" ReorderLevel,LedgerName ");
            sb.Append(" FROM ( ");
            sb.Append("    SELECT t1.PuschaseRequistionDetailID,t1.PurchaseRequisitionNo,t1.ItemName,t1.ItemID,t1.RequestedQty,t1.ApprovedQty, t1.OrderedQty, ");
            sb.Append("     IFNULL(t1.Discount,auto.discount)Discount,t1.Specification,t1.Purpose,t1.ProbableVendorID,IFNULL(t1.ApproxRate,auto.Rate)ApproxRate,t1.InHandQty,IFNULL(t1.Issue,0)Issue,IFNULL(t1.ReturnUnit,0)ReturnUnit,  ");
            sb.Append("    t1.CurrentStock,t1.ReorderLevel,(SELECT VendorName FROM f_vendormaster WHERE vendor_id=auto.VendorID)LedgerName        ");
            sb.Append("    FROM ( ");
            sb.Append("        SELECT prd.PuschaseRequistionDetailID,prd.PurchaseRequisitionNo,prd.ItemName,prd.ItemID,  ");
            sb.Append("        prd.RequestedQty,prd.ApprovedQty,prd.OrderedQty,prd.Discount, prd.Specification, prd.Purpose,prd.ProbableVendorID,  ");
            sb.Append("        prd.ApproxRate,prd.InHandQty, ");
            sb.Append("        (SELECT SUM(SoldUnits) FROM f_salesdetails  WHERE itemID=prd.itemID AND  ");
            sb.Append("        DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(3,13))Issue , ");
            sb.Append("        (SELECT SUM(SoldUnits) FROM f_salesdetails  WHERE itemID=prd.itemID AND  ");
            sb.Append("        DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(5,14))ReturnUnit , ");
            sb.Append("        (SELECT SUM(InitialCount-ReleasedCount) FROM f_stock st WHERE st.itemid=prd.ItemID AND st.CentreID='" + ViewState["CentreID"].ToString() + "' ");
            sb.Append("        GROUP BY st.itemid)CurrentStock, ");
            sb.Append("        IFNULL(ReorderLevel,0)ReorderLevel FROM  f_purchaserequestdetails prd  ");
            sb.Append("        INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID  ");
            sb.Append("        WHERE prd.PurchaseRequisitionNo IN(" + PRNOs + ") AND prd.itemid IN  ");
            sb.Append("        (" + ItemIDs + ")  AND prd.Status <> 2 AND prd.CentreID='" + ViewState["CentreID"].ToString() + "' ORDER BY prd.PurchaseRequisitionNo,prd.ItemName  ");
            sb.Append("    )t1 LEFT JOIN AutopoQuotation auto ON auto.ItemID=t1.ItemID AND  DATE(DateUpto)>=CURDATE() AND isActive=1 ");

            sb.Append("  )t2 ");

        }
        dtItemDetails = StockReports.GetDataTable(sb.ToString());
        if (dtItemDetails != null && dtItemDetails.Rows.Count > 0)
        {
            grdAutoPo.DataSource = dtItemDetails;
            grdAutoPo.DataBind();
        }
        else
        {
            grdAutoPo.DataSource = null;
            grdAutoPo.DataBind();
        }
    }

    private DataTable BindTax(string PRDetailID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select pr.TaxID,CONCAT(pr.TaxPer,'%')TaxPer,tm.TaxName,pr.PRDetailID from f_prtax pr inner join f_taxmaster tm");
        sb.Append(" on pr.TaxID = tm.TaxID where pr.PRDetailID = '" + PRDetailID + "' and tm.TaxID<>'T5' ");
        sb.Append(" union ");
        sb.Append("select pr.TaxID,CONCAT('','Rs.',pr.TaxAmt)TaxPer,tm.TaxName,pr.PRDetailID from f_prtaxexcise pr inner join f_taxmaster tm");
        sb.Append(" on pr.TaxID = tm.TaxID where pr.PRDetailID = '" + PRDetailID + "' and tm.TaxID='T5' ");

        DataTable dtTax = new DataTable();
        dtTax = StockReports.GetDataTable(sb.ToString());

        return dtTax;
    }


    #endregion

    protected void btnGRNCancel_Click(object sender, EventArgs e)
    {
        string PRNO = lblPRNo2.Text;
        string Reason = txtCancelReason.Text;
        if (ViewState["LedgerNumber"] != null)
        {
            string EMPID = string.Empty, EMPName = string.Empty, LedgerNumber = string.Empty, value = string.Empty;
            EMPID = Convert.ToString(Session["ID"]);
            EMPName = Convert.ToString(Session["UserName"]);
            bool Result = false;

            LedgerNumber = ViewState["LedgerNumber"].ToString();
            value = "aaa";

            string str = "call UpdatePurchaseReqApproval('" + PRNO + "','" + EMPID + "','" + EMPName + "','" + value + "',2,0)";
            Result = StockReports.ExecuteDML(str.ToString());
            StockReports.ExecuteDML("update f_purchaserequestmaster set ReasonOfRejection='" + Reason + "',RejectedBy='" + EMPID + "',RejectedDate=CURRENT_TIMESTAMP() WHERE PurchaseRequestNo='" + PRNO + "'");
            if (Result)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblmsg.ClientID + "');", true);
                BindPRRequest(EMPID, LedgerNumber);
                grdItemDetails.DataSource = null;
                grdItemDetails.DataBind();

            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
    protected void btnRejectItem_Click(object sender, EventArgs e)
    {

        string EmpID = string.Empty;
        EmpID = Convert.ToString(Session["ID"]);
        string LedgerNumber = ViewState["LedgerNumber"].ToString();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string PRDetailID = lblPRNO1.Text;
            string ItemID = lblitemid.Text;
            string ItemName = lblItemName1.Text;
            string PurchaseRequisitionNo = lblreqno.Text;
            string ReasonItem = txtItemReason.Text;
            string strQuery = string.Empty;
            strQuery = "  UPDATE f_purchaserequestdetails SET Approved=2,STATUS=2,ApprovalDate=CURRENT_TIMESTAMP()  where  PuschaseRequistionDetailID=" + PRDetailID + "";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strQuery);
            con.Close();
            con.Dispose();

            string prno = GetPRNO();
            if (prno != string.Empty)
                GetSelectedItems(prno);
            else
                lblmsg.Text = "Select Request";


            string strQuerynew = string.Empty;
            strQuerynew = " SELECT PuschaseRequistionDetailID,PurchaseRequisitionNo,ItemName,ItemID,RequestedQty,ApprovedQty,OrderedQty,Discount, Specification,Purpose,ProbableVendorID,ApproxRate,InHandQty FROM f_purchaserequestdetails   WHERE PurchaseRequisitionNo IN ('" + PurchaseRequisitionNo + "')  AND STATUS <> 2 ";
            dtItemDetails = StockReports.GetDataTable(strQuerynew);
            StockReports.ExecuteDML("update f_purchaserequestdetails set ReasonOfRejection='" + ReasonItem + "',RejectedUserID='" + EmpID + "',RejectedDate=CURRENT_TIMESTAMP() WHERE PuschaseRequistionDetailID=" + PRDetailID + "");
            if (dtItemDetails.Rows.Count == 0)
            {

                if (ViewState["LedgerNumber"] != null)
                {
                    string EMPID = string.Empty, EMPName = string.Empty, value = string.Empty;
                    EMPID = Convert.ToString(Session["ID"]);
                    EMPName = Convert.ToString(Session["UserName"]);
                    bool Result = false;
                    LedgerNumber = ViewState["LedgerNumber"].ToString();
                    string PRNO = string.Empty;
                    value = "aaa";
                    PRNO = PurchaseRequisitionNo;
                    string str = "call UpdatePurchaseReqApproval('" + PRNO + "','" + EMPID + "','" + EMPName + "','" + value + "',2,0)";
                    Result = StockReports.ExecuteDML(str.ToString());
                    StockReports.ExecuteDML("update f_purchaserequestmaster set ReasonOfRejection='" + ReasonItem + "',RejectedBy='" + EmpID + "',RejectedDate=CURRENT_TIMESTAMP() WHERE PurchaseRequestNo='" + PRNO + "'");

                    if (Result)
                    {
                        BindPRRequest(EMPID, LedgerNumber);
                        grdItemDetails.DataSource = null;
                        grdItemDetails.DataBind();
                        txtItemReason.Text = "";
                    }
                    else
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
                }
            }
            txtItemReason.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblmsg.ClientID + "');", true);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            con.Close();
            con.Dispose();

        }

    }
    protected void btnSaveAuto_Click(object sender, EventArgs e)
    {
        MySqlConnection conn;
        MySqlTransaction tnx;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
        {
            conn.Open();
        }
        tnx = conn.BeginTransaction();
        try
        {

            string PRNO = string.Empty, IsLast = string.Empty, PAEmpId = string.Empty, EMPID = string.Empty;
            string EMPName = string.Empty, LedgerNumber = string.Empty, value = string.Empty;
            string PRNOs = string.Empty;
            string ItemIDs = string.Empty;
            bool Result = false;
            value = "aaa";
            EMPID = Convert.ToString(Session["ID"]);
            EMPName = Convert.ToString(Session["UserName"]);
            string PONumber = "";
            if (ViewState["LedgerNumber"] != null)
            {
                LedgerNumber = ViewState["LedgerNumber"].ToString();

                if (rdbPRApproval.SelectedItem.Value == "Approve")
                {

                    if (grdAutoPo.Rows.Count > 0)
                    {
                        foreach (GridViewRow gr in grdAutoPo.Rows)
                        {
                            if (((CheckBox)gr.FindControl("chkSelectNew")).Checked == true)
                            {
                                string PRAuto = ((Label)gr.FindControl("lblPRNOAuto")).Text;
                                string ItemAuto = ((Label)gr.FindControl("lblItemIDAuto")).Text;
                                if (PONumber == "")
                                {
                                    AutoPo apo = new AutoPo(tnx);
                                    apo.PRNo = PRAuto;
                                    apo.UserID = EMPID;
                                    apo.UserName = EMPName;
                                    apo.PAUserID = value;
                                    apo.PRstatus = "1";
                                    apo.AppTypeID = "0";
                                    apo.ItemID = ItemAuto;
                                    apo.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                    apo.Hospital_ID = Util.GetString(Session["HODPID"]);
                                    PONumber = apo.Insert();
                                }
                                else
                                {
                                    AutoPo apo = new AutoPo(tnx);
                                    apo.PRNo = PRAuto;
                                    apo.UserID = EMPID;
                                    apo.UserName = EMPName;
                                    apo.PAUserID = value;
                                    apo.PRstatus = "1";
                                    apo.AppTypeID = "0";
                                    apo.ItemID = ItemAuto;
                                    apo.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                    apo.Hospital_ID = Util.GetString(Session["HODPID"]);
                                    PONumber = PONumber + "," + apo.Insert();
                                }
                            }
                        }
                    }

                }

                if (rdbPRApproval.SelectedItem.Value == "Approve")
                {
                    for (int i = 0; i < GridView1.Rows.Count; i++)
                    {
                        if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked)
                        {
                            PRNO = "'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "call UpdatePurchaseReqApproval(" + PRNO + ",'" + EMPID + "','" + EMPName + "','" + value + "',1,0)");
                            if (result > 0)
                            {
                                Result = true;
                            }
                            else
                            {
                                Result = false;
                            }
                        }
                    }

                }

                else
                {
                    for (int i = 0; i < GridView1.Rows.Count; i++)
                    {
                        if (((CheckBox)GridView1.Rows[i].FindControl("chkSelect")).Checked == true)
                        {
                            PRNO = "'" + ((Label)GridView1.Rows[i].FindControl("lblPRNO")).Text + "'";
                            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "call UpdatePurchaseReqApproval(" + PRNO + ",'" + EMPID + "','" + EMPName + "','" + value + "',2,0)");
                            if (result > 0)
                            {
                                Result = true;
                            }
                            else
                            {
                                Result = false;
                            }
                        }
                    }
                }

                if (PONumber != "")
                {

                    string[] PONumberArr = PONumber.ToString().Split(',');
                    if (chkPrintImgAuto.Checked == true)
                    {
                        int i = 2;

                        foreach (string Po in PONumberArr)
                        {

                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key" + i.ToString(), "window.open('POReport.aspx?PONumber=" + Po + "&ImageToPrint=" + 1 + "');location.href='PRApproval.aspx';", true);
                            i++;
                        }
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Auto PurchaseOrder No. : " + PONumber + "');", true);
                    }
                    else
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Auto PurchaseOrder No. : " + PONumber + "');", true);
                }
                if (Result == true)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM030','" + lblmsg.ClientID + "');", true);
                    tnx.Commit();
                    tnx.Dispose();
                    conn.Close();
                    conn.Dispose();
                    BindPRRequest(EMPID, LedgerNumber);
                    grdItemDetails.DataSource = null;
                    grdItemDetails.DataBind();

                }
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            tnx.Rollback();
            tnx.Dispose();
            conn.Close();
            conn.Dispose();
        }
    }
    private bool ValidateGrid()
    {
        int status = 0;
        foreach (GridViewRow gr in GridView1.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSelect")).Checked == true)
            {
                status = 1;
                break;
            }
        }
        if (status == 1)
            return true;
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblmsg.ClientID + "');", true);
            return false;
        }
    }

    private void BindDepartment()
    {
        //string str = "SELECT LedgerNumber,LedgerName FROM  f_ledgermaster lm INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo=lm.LedgerNumber "+
        //             " WHERE rm.IsStore=1 AND GroupID='DPT' and IsCurrent=1 order by LedgerName ";
        //DataTable dt = StockReports.GetDataTable(str);
        DataTable dt = LoadCacheQuery.bindStoreDepartment();
        DataView dv = dt.DefaultView;
        string CentreID = Session["CentreID"].ToString();
        var ledgerNumber = StockReports.ExecuteScalar("SELECT DISTINCT GROUP_CONCAT(CONCAT('''',rm.DeptLedgerNo,'''')) FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.id AND cr.isActive=1 WHERE cr.CentreID IN (" + CentreID + ") AND cr.isActive=1 AND rm.IsStore=1");
        dv.RowFilter = "ledgerNumber in (" + ledgerNumber + ") ";
        dt = dv.ToTable().AsEnumerable().Where(r => r.Field<int>("IsStore") == 1).AsDataView().ToTable(); ;
        if (dt != null && dt.Rows.Count > 0)
        {
            ddldepartment.DataSource = dt;
            ddldepartment.DataTextField = "LedgerName";
            ddldepartment.DataValueField = "LedgerNumber";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("All", "0"));
            ddldepartment.SelectedIndex = ddldepartment.Items.IndexOf(ddldepartment.Items.FindByValue(ViewState["CurDeptLedgerNo"].ToString()));
        }
        else
        {
            ddldepartment.DataSource = null;
            ddldepartment.DataBind();
        }
    }
    protected void ddldepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPurchaseGrid();
    }
    private void BindPurchaseGrid()
    {
        string EmpID = string.Empty;
        EmpID = Convert.ToString(Session["ID"]);
        string LedgerNumber = rdbLedMas.SelectedItem.Value;
        ViewState.Add("LedgerNumber", LedgerNumber);
        BindPRRequest(EmpID, LedgerNumber);
        ViewState["UserID"] = EmpID;
        grdItemDetails.DataSource = null;
        grdItemDetails.DataBind();
    }
}
