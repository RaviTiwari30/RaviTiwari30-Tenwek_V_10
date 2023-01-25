using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_BloodBank_BloodRequest : System.Web.UI.Page
{
    private DataTable dtItem;
    protected void btnDispatch_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IssueQty = 0;
            foreach (GridViewRow gr in grdRequestList.Rows)
            {
                if (((CheckBox)gr.FindControl("chkYes")).Checked)
                {
                    IssueQty = IssueQty + 1;
                }
            }
            decimal record = Util.GetDecimal(lblQtypending.Text);
            if (IssueQty > record)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM206','" + lblMsg.ClientID + "');", true);
                //lblMsg.Text = "Issue Qty Cannot be Greater Than Requested Qty";
                return;
            }
            foreach (GridViewRow gr in grdRequestList.Rows)
            {
                if (((CheckBox)gr.FindControl("chkYes")).Checked)
                {
                    decimal vol = Util.GetDecimal(((Label)gr.FindControl("lblInitialCount")).Text);
                    int count = Util.GetInt(((Label)gr.FindControl("lblID1")).Text);
                    DispatchBlood db = new DispatchBlood(Tranx);
                    db.IssueVolumn = vol;
                    db.componentid = Util.GetInt(((Label)gr.FindControl("lblcomponentid")).Text);
                    db.DispatchBy = Session["ID"].ToString();
                    db.CentreId = Util.GetInt(Session["CentreID"].ToString());
                    db.PatientID = lblPatientId.Text;
                    db.LedgerTransactionNo = lblLedgerTransactionNo.Text;
                    db.TransactionID = lblTransaction_ID.Text;
                    db.Stock_ID = ((Label)gr.FindControl("lblStockId1")).Text;
                    db.ComponentName = ((Label)gr.FindControl("lblComponentName")).Text;
                    db.BBTubeNo = ((Label)gr.FindControl("lblBBTubeNo")).Text;
                    db.BagType = ((Label)gr.FindControl("lblbagtype")).Text;
                    db.Expiry = Util.GetDateTime(((Label)gr.FindControl("lblExpiry")).Text);
                    db.vTYPE = Util.GetString(lblTypeOfTnx.Text.ToString().ToUpper());
                    db.IsDispatch = 0;
                    db.ItemID = Util.GetString(lblItemID.Text.ToString());
                    db.LedgerTnxID = lblLedgerTnxID.Text.ToString();

                    db.Insert();
                    string up8 = "UPDATE bb_stock_master SET IsDispatch=1,DispatchBy='" + Session["ID"].ToString() + "',status=0,DispatchDate=now() where ID=" + count + " ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up8);
                    string up2 = "UPDATE f_ledgertnxdetail SET BloodIssue=BloodIssue+" + 1 + " where LedgerTnxID='" + lblLedgerTnxID.Text + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);
                }
                //else
                //{
                //    lblMsg.Text = "Please Select Stock to Dispath";
                //    return;
                //}
            }
            Tranx.Commit();

            pnlSearch.Visible = false;
            pnlRequest.Visible = false;
            grdRequestList.DataSource = null;
            grdRequestList.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "Record Saved Sucessfully";
            search1();
            if (grdTran.Rows.Count == 0)
            {
                search("");
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text=ex.Message;
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        search("1");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
                foreach (GridViewRow gr in grdreject.Rows)
                {
                    if (((Label)gr.FindControl("lblRtnxType")).Text == "O")//OPD
                    {
                        string str = "select * from f_ledgertnxdetail where LedgerTnxID='" + ((Label)gr.FindControl("lblLedgerTnxID")).Text.ToString() + "' ";
                        DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, str).Tables[0];

                        if (Util.GetDecimal(((TextBox)gr.FindControl("lblRejectQty")).Text.ToString()) > Util.GetDecimal(((Label)gr.FindControl("lblPendingQty")).Text.ToString()))
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM207','" + lblMsg.ClientID + "');", true);
                            mpeReject.Show();
                            return;
                        }

                        LedgerTnxDetail tnxdtl = new LedgerTnxDetail(tnx);

                        tnxdtl.Location = Util.GetString(dt.Rows[0]["Location"]);
                        tnxdtl.HospCode = Util.GetString(dt.Rows[0]["HospCode"]);
                        tnxdtl.Hospital_Id = Util.GetString(dt.Rows[0]["Hospital_Id"]);
                        tnxdtl.LedgerTransactionNo = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
                        tnxdtl.Amount = Util.GetDecimal(dt.Rows[0]["Amount"]) * -1;
                        tnxdtl.ItemID = Util.GetString(dt.Rows[0]["ItemID"]);
                        tnxdtl.Rate = Util.GetDecimal(dt.Rows[0]["Rate"]) * 1;
                        tnxdtl.Quantity = Util.GetDecimal(((TextBox)gr.FindControl("lblRejectQty")).Text.ToString()) * -1; ;
                        tnxdtl.StockID = Util.GetString(dt.Rows[0]["StockID"]);
                        tnxdtl.IsTaxable = Util.GetString(dt.Rows[0]["IsTaxable"]);
                        tnxdtl.DiscountPercentage = Util.GetDecimal(dt.Rows[0]["DiscountPercentage"]);
                        tnxdtl.IsPackage = Util.GetInt(dt.Rows[0]["IsPackage"]);
                        tnxdtl.PackageID = Util.GetString(dt.Rows[0]["PackageID"]);
                        tnxdtl.IsVerified = Util.GetInt(dt.Rows[0]["IsVerified"]);
                        tnxdtl.SubCategoryID = Util.GetString(dt.Rows[0]["SubCategoryID"]);
                        tnxdtl.VarifiedUserID = Util.GetString(dt.Rows[0]["VarifiedUserID"]);
                        tnxdtl.ItemName = Util.GetString(dt.Rows[0]["ItemName"]);
                        tnxdtl.TransactionID = Util.GetString(dt.Rows[0]["TransactionID"]);
                        tnxdtl.VerifiedDate = Util.GetDateTime(dt.Rows[0]["VerifiedDate"]);
                        tnxdtl.UserID = Util.GetString(dt.Rows[0]["UserID"]);
                        tnxdtl.EntryDate = Util.GetDateTime(dt.Rows[0]["EntryDate"]);
                        tnxdtl.IsFree = Util.GetInt(dt.Rows[0]["IsFree"]);
                        tnxdtl.IsSurgery = Util.GetInt(dt.Rows[0]["IsSurgery"]);
                        tnxdtl.SurgeryID = Util.GetString(dt.Rows[0]["Surgery_ID"]);
                        tnxdtl.SurgeryName = Util.GetString(dt.Rows[0]["SurgeryName"]);
                        tnxdtl.DoctorID = Util.GetString(dt.Rows[0]["DiscountReason"]);
                        tnxdtl.DoctorCharges = Util.GetDecimal(dt.Rows[0]["DiscAmt"]);
                        tnxdtl.TnxTypeID = Util.GetInt(dt.Rows[0]["TnxTypeID"]);
                        tnxdtl.DiscAmt = Util.GetDecimal(dt.Rows[0]["DiscAmt"]);
                        tnxdtl.IsMedService = Util.GetInt(dt.Rows[0]["IsMedService"]);
                        tnxdtl.LastUpdatedBy = Util.GetString(dt.Rows[0]["LastUpdatedBy"]);
                        tnxdtl.UpdatedDate = Util.GetDateTime(dt.Rows[0]["Updatedate"]);
                        //tnxdtl.IpAddress = Util.GetString(dt.Rows[0]["IpAddress"]);
                        tnxdtl.ToBeBilled = Util.GetInt(dt.Rows[0]["ToBeBilled"]);
                        tnxdtl.IsReusable = Util.GetString(dt.Rows[0]["IsReusable"]);
                        tnxdtl.Type_ID = Util.GetString(dt.Rows[0]["Type_ID"]);
                        tnxdtl.ConfigID = Util.GetInt(dt.Rows[0]["ConfigID"]);
                        tnxdtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        tnxdtl.DoctorID = Util.GetString(dt.Rows[0]["DoctorID"]);
                        tnxdtl.typeOfTnx = Util.GetString(dt.Rows[0]["TypeOfTnx"]);
                        tnxdtl.Type = Util.GetString(dt.Rows[0]["Type"]);
                        tnxdtl.pageURL = All_LoadData.getCurrentPageName();
                        int newLedgerTnxID = tnxdtl.Insert();

                        //string up2 = "UPDATE f_ledgertnxdetail SET Quantity=Quantity-'" + ((TextBox)gr.FindControl("lblRejectQty")).Text + "' where LedgerTnxID= '" + ((Label)gr.FindControl("lblLedgerTnxID")).Text.ToString() + "' ";
                        //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, up2);

                    }
                    else if (((Label)gr.FindControl("lblRtnxType")).Text == "I" || ((Label)gr.FindControl("lblRtnxType")).Text == "E")
                    {
                        if (Util.GetDecimal(((TextBox)gr.FindControl("lblRejectQty")).Text.ToString()) > Util.GetDecimal(((Label)gr.FindControl("lblPendingQty")).Text.ToString()))
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM207','" + lblMsg.ClientID + "');", true);
                            mpeReject.Show();
                            return;
                        }

                        string strr = "select * from f_ledgertnxdetail where LedgerTnxID='" + ((Label)gr.FindControl("lblLedgerTnxID")).Text.ToString() + "' ";
                        DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, strr).Tables[0];

                        LedgerTnxDetail tnxdtl = new LedgerTnxDetail(tnx);

                        tnxdtl.Location = Util.GetString(dt.Rows[0]["Location"]);
                        tnxdtl.HospCode = Util.GetString(dt.Rows[0]["HospCode"]);
                        tnxdtl.Hospital_Id = Util.GetString(dt.Rows[0]["Hospital_Id"]);
                        tnxdtl.LedgerTransactionNo = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
                        tnxdtl.Amount = Util.GetDecimal(dt.Rows[0]["Amount"]) * -1;
                        tnxdtl.ItemID = Util.GetString(dt.Rows[0]["ItemID"]);
                        tnxdtl.Rate = Util.GetDecimal(dt.Rows[0]["Rate"]) * 1;
                        tnxdtl.Quantity = Util.GetDecimal(((TextBox)gr.FindControl("lblRejectQty")).Text.ToString()) * -1; ;
                        tnxdtl.StockID = Util.GetString(dt.Rows[0]["StockID"]);
                        tnxdtl.IsTaxable = Util.GetString(dt.Rows[0]["IsTaxable"]);
                        tnxdtl.DiscountPercentage = Util.GetDecimal(dt.Rows[0]["DiscountPercentage"]);
                        tnxdtl.IsPackage = Util.GetInt(dt.Rows[0]["IsPackage"]);
                        tnxdtl.PackageID = Util.GetString(dt.Rows[0]["PackageID"]);
                        tnxdtl.IsVerified = Util.GetInt(dt.Rows[0]["IsVerified"]);
                        tnxdtl.SubCategoryID = Util.GetString(dt.Rows[0]["SubCategoryID"]);
                        tnxdtl.VarifiedUserID = Util.GetString(dt.Rows[0]["VarifiedUserID"]);
                        tnxdtl.ItemName = Util.GetString(dt.Rows[0]["ItemName"]);
                        tnxdtl.TransactionID = Util.GetString(dt.Rows[0]["TransactionID"]);
                        tnxdtl.VerifiedDate = Util.GetDateTime(dt.Rows[0]["VerifiedDate"]);
                        tnxdtl.UserID = Util.GetString(dt.Rows[0]["UserID"]);
                        tnxdtl.EntryDate = Util.GetDateTime(dt.Rows[0]["EntryDate"]);
                        tnxdtl.IsFree = Util.GetInt(dt.Rows[0]["IsFree"]);
                        tnxdtl.IsSurgery = Util.GetInt(dt.Rows[0]["IsSurgery"]);
                        tnxdtl.SurgeryID = Util.GetString(dt.Rows[0]["SurgeryID"]);
                        tnxdtl.SurgeryName = Util.GetString(dt.Rows[0]["SurgeryName"]);
                        tnxdtl.DoctorID = Util.GetString(dt.Rows[0]["DiscountReason"]);
                        tnxdtl.DoctorCharges = Util.GetDecimal(dt.Rows[0]["DiscAmt"]);
                        tnxdtl.TnxTypeID = Util.GetInt(dt.Rows[0]["TnxTypeID"]);
                        tnxdtl.DiscAmt = Util.GetDecimal(dt.Rows[0]["DiscAmt"]);
                        tnxdtl.IsMedService = Util.GetInt(dt.Rows[0]["IsMedService"]);
                        tnxdtl.LastUpdatedBy = Util.GetString(dt.Rows[0]["LastUpdatedBy"]);
                        tnxdtl.UpdatedDate = Util.GetDateTime(dt.Rows[0]["Updatedate"]);
                        //tnxdtl.IpAddress = Util.GetString(dt.Rows[0]["IpAddress"]);
                        tnxdtl.ToBeBilled = Util.GetInt(dt.Rows[0]["ToBeBilled"]);
                        tnxdtl.IsReusable = Util.GetString(dt.Rows[0]["IsReusable"]);
                        tnxdtl.Type_ID = Util.GetString(dt.Rows[0]["Type_ID"]);
                        tnxdtl.ConfigID = Util.GetInt(dt.Rows[0]["ConfigID"]);
                        tnxdtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        tnxdtl.DoctorID = Util.GetString(dt.Rows[0]["DoctorID"]);
                        tnxdtl.typeOfTnx = Util.GetString(dt.Rows[0]["TypeOfTnx"]);
                        tnxdtl.Type = Util.GetString(dt.Rows[0]["Type"]);
                        tnxdtl.pageURL = All_LoadData.getCurrentPageName();
                        int newLedgerTnxID = tnxdtl.Insert();
                        if (newLedgerTnxID == 0)
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Error occurred, Please contact administrator');", true);
                            mpeReject.Show();
                            return;
                        }

                        string str = "UPDATE ipdservices_request SET RejectQty=ifnull(RejectQty,0)+" + Util.GetDecimal(((TextBox)gr.FindControl("lblRejectQty")).Text.ToString()) + ",IsCancel=1,  Cancelby='" + Session["ID"].ToString() + "',  CancelDate=NOW(),  CancelReason='' WHERE id='" + lblServiceID.Text.Trim() + "' ";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    }
                }
            tnx.Commit();
            lblMsg.Text = "Request Rejected Successfully";
            grdreject.DataSource = null;
            grdreject.DataBind();
            //search1();
            //if (grdTran.Rows.Count == 0)
            //{
            search("");
            //  }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            con.Close();
            tnx.Dispose();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search("");
    }

    protected void chkYes_OnCheckedChanged(object sender, EventArgs e)
    {
        GridEnable();
    }

    protected void clear()
    {
    }

    //protected void grdSearchList_RowCommand(object sender, GridViewCommandEventArgs e)
    //{

    //    //  lblQtypending.Text = lblRequestQty.Text;// ((Label)grdSearchList.Rows[index].FindControl("lblPendQuantity")).Text;
    //    if (e.CommandName == "AResult")
    //    {
    //        int index = Convert.ToInt32((e.CommandArgument));
    //        lblServiceID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblServiceID")).Text;
    //        lblPatientId.Text = ((Label)grdSearchList.Rows[index].FindControl("lblPatientId1")).Text;
    //        lblTransactionID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblTransactionID1")).Text;
    //        lblLedgerTransactionNo.Text = ((Label)grdSearchList.Rows[index].FindControl("lblLedgerTransactionNo1")).Text;
    //        lblLedgerTnxID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblLedgerTnxID1")).Text;
    //        lblTypeOfTnx.Text = ((Label)grdSearchList.Rows[index].FindControl("lblTnxType1")).Text;
    //        lblPID.Text = "UHID: " + ((Label)grdSearchList.Rows[index].FindControl("lblPatientId1")).Text;
    //        lblPName.Text = "Name: " + ((Label)grdSearchList.Rows[index].FindControl("lblName")).Text;
    //        lblPBloodGroup.Text = "Blood Group: ";
    //        lblBloodGroup.Text = (((Label)grdSearchList.Rows[index].FindControl("lblBlood")).Text);
    //        ddlBloodGroup.SelectedIndex = ddlBloodGroup.Items.IndexOf(ddlBloodGroup.Items.FindByText(((Label)grdSearchList.Rows[index].FindControl("lblBlood")).Text));
    //        string Trans_ID = "";
    //        if (lblTypeOfTnx.Text == "IPD")
    //        {
    //            lblPIPDNo.Text = "IPD No.: " + ((Label)grdSearchList.Rows[index].FindControl("lblTransactionID1")).Text.Replace("ISHHI", "");
    //            Trans_ID = ((Label)grdSearchList.Rows[index].FindControl("lblTransactionID1")).Text;
    //        }
    //        else if (lblTypeOfTnx.Text == "EMG")
    //        {
    //            lblPIPDNo.Text = "EMG No.: " + ((Label)grdSearchList.Rows[index].FindControl("lblEmergencyNo1")).Text;
    //            Trans_ID = ((Label)grdSearchList.Rows[index].FindControl("lblTransactionID1")).Text; ;
    //        }
    //        if (lblTypeOfTnx.Text == "OPD")
    //            lblQtypending.Text = ((Label)grdSearchList.Rows[index].FindControl("lblPendQuantity")).Text;
    //        else
    //            lblQtypending.Text = (StockReports.ExecuteScalar("SELECT (Quantity - (RejectQty+IFNULL((SELECT COUNT(ServiceRequestID) FROM bb_blood_CrossMatch cm WHERE cm.ServiceRequestID=isr.ID AND isUnReserved=0 AND compatiblity<>'UnCompatible'),0))) FROM ipdservices_request isr  WHERE ID=" + lblServiceID.Text.Trim() + " "));
    //        lblRequestQty.Text = "Pending Qty : " + lblQtypending.Text; //((Label)grdSearchList.Rows[index].FindControl("lblPendQuantity")).Text;
    //        lblComponentName.Text = "Component : " + ((Label)grdSearchList.Rows[index].FindControl("lblConponentName")).Text;
    //        lblPanelID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblPanelID")).Text;
    //        lblIPDCaseType_Id.Text = ((Label)grdSearchList.Rows[index].FindControl("lblIPDCaseType_Id")).Text;
    //        lblComponent1.Text = ((Label)grdSearchList.Rows[index].FindControl("lblIscomponent")).Text;
    //        lblItemID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblItemID1")).Text;

    //        pnlRequest.Visible = true;
    //        pnlTran.Visible = false;
    //        grdRequestList.DataSource = null;
    //        grdRequestList.DataBind();
    //        string CompatibleBloodGroup = "";
    //        if (lblBloodGroup.Text != "NA")
    //            CompatibleBloodGroup = StockReports.ExecuteScalar("SELECT GROUP_CONCAT(CONCAT('''',bgc.TOBG,''''))BG FROM bb_grouping_compatible bgc WHERE bgc.FromaBG='" + lblBloodGroup.Text + "'");


    //        StringBuilder sb2 = new StringBuilder();

    //        sb2.Append(" SELECT IF(IFNULL(bcm.BloodStockID,'0')='0',0,1)IsCrossMatch,ifnull(bcm.IsUnReserved,0)IsUnReserved, sm.id,sm.stock_ID,cm.componentname,sm.componentid,(sm.InitialCount-sm.ReleaseCount)InitialCount,sm.bagtype,sm.BloodCollection_Id,sm.BBTubeNo,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,'1' HaveComponent,sm.BloodGroup,DATE_FORMAT(sm.EntryDate,'%d-%b-%Y')EntryDate,Compatiblity,cm.isCrosschargesapply FROM bb_stock_master sm ");
    //        sb2.Append(" LEFT JOIN bb_blood_CrossMatch bcm ON bcm.BloodStockID =sm.Stock_Id AND bcm.TransactionID='" + Trans_ID + "' inner JOIN  bb_component_master cm ON cm.Id=sm.componentid AND  cm.ID in (SELECT componentid FROM bb_item_component WHERE itemid='" + lblItemID.Text + "' and isactive=1) AND sm.Stock_Id NOT IN (SELECT BloodStockID FROM bb_blood_CrossMatch bcm WHERE bcm.BloodStockID =sm.Stock_Id AND IsUnReserved=0 AND bcm.Compatiblity<>'UnCompatible') WHERE sm.IsActive=1  ");
    //        sb2.Append(" AND Date(sm.ExpiryDate)>=Date(NOW()) And sm.InitialCount>sm.ReleaseCount  AND sm.status=1 AND sm.IsDispatch=0 AND sm.IsDiscarded=0 AND sm.IsHold=0 and sm.centreID='" + Session["CentreID"].ToString() + "' ");
    //        if (CompatibleBloodGroup != "")
    //            sb2.Append(" AND sm.BloodGroup IN (" + CompatibleBloodGroup + ") ");
    //        sb2.Append(" GROUP BY sm.stock_id");

    //        DataTable dt = StockReports.GetDataTable(sb2.ToString());
    //        if (dt.Rows.Count > 0)
    //        {
    //            grdRequestList.DataSource = dt;
    //            grdRequestList.DataBind();
    //            lblStockID.Text = dt.Rows[0]["stock_ID"].ToString();
    //            if (lblTypeOfTnx.Text == "OPD")
    //            {
    //                btnShowStock.Enabled = true;
    //                btnCrossMatch.Enabled = false;
    //            }
    //            else if (lblTypeOfTnx.Text == "IPD" || lblTypeOfTnx.Text == "EMG")
    //            {
    //                btnShowStock.Enabled = false;
    //                btnCrossMatch.Enabled = true;
    //            }
    //        }
    //        else
    //        {
    //            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    //            lblMsg.Text = "No Stock Found";
    //            btnShowStock.Enabled = false;
    //            btnDispatch.Enabled = false;
    //            pnlRequest.Visible = false;
    //        }
    //        //  }
    //        //   }
    //    }
    //    else if (e.CommandName == "AIssue")
    //    {
    //        int index = Convert.ToInt32((e.CommandArgument));
    //        lblServiceID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblServiceID")).Text;
    //        lblPatientId.Text = ((Label)grdSearchList.Rows[index].FindControl("lblPatientId1")).Text;
    //        lblTransactionID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblTransactionID1")).Text;
    //        lblPanelID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblPanelID")).Text;
    //        lblIPDCaseType_Id.Text = ((Label)grdSearchList.Rows[index].FindControl("lblIPDCaseType_Id")).Text;
    //        lblItemID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblItemID1")).Text;
    //        string Type = ((Label)grdSearchList.Rows[index].FindControl("lblEmergencyNo")).Text;
    //        if (Type == "")
    //            Type = "IPD";
    //        else
    //            Type = "EMG";
    //        string str1 = "SELECT '" + Type + "' As Type,bcm.TransactionID,bcm.ItemID,bcm.ComponentID,bcm.ComponentName,bcm.BloodStockID,sm.BBTubeNo,bcm.ServiceRequestID,IF((sm.InitialCount-sm.ReleaseCount)>0,0,1)IsIssue  FROM bb_blood_crossmatch bcm INNER JOIN bb_stock_master sm ON bcm.BloodStockID=sm.Stock_Id AND UCASE(bcm.Compatiblity)<>'UNCOMPATIBLE' WHERE bcm.ServiceRequestID='" + lblServiceID.Text + "'  GROUP BY sm.stock_id";
    //        DataTable dt = StockReports.GetDataTable(str1);
    //        if (dt.Rows.Count > 0)
    //        {
    //            grdIssue.DataSource = dt;
    //            grdIssue.DataBind();
    //            mpeIssue.Show();
    //        }
    //        else
    //        {
    //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    //        }
    //    }
    //    else if (e.CommandName == "Areject")
    //    {
    //        int index = Convert.ToInt32((e.CommandArgument));
    //        lblLedgerTransactionNo.Text = ((Label)grdSearchList.Rows[index].FindControl("lblLedgerTransactionNo1")).Text;
    //        lblLedgerTnxID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblLedgerTnxID1")).Text;
    //        lblTypeOfTnx.Text = ((Label)grdSearchList.Rows[index].FindControl("lblTnxType1")).Text;
    //        lblServiceID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblServiceID")).Text;

    //        string str = "";
    //        if (lblTypeOfTnx.Text == "OPD")
    //        {
    //            string LedTransactionNo = lblLedgerTnxID.Text;
    //            string Item = lblItemID.Text;
    //            str = "select ltd.ItemName,ltd.itemid,ltd.LedgerTnxID,ltd.Quantity RequestedQty,(SUM(ltd.Quantity)-(SUM(ltd.BloodIssue)))PendingQty,'OPD' Patient_Type from f_ledgertnxdetail ltd where LedgerTnxID='" + LedTransactionNo + "'AND itemid='" + Item + "' GROUP BY LedgerTransactionNo";
    //        }
    //        else
    //        {
    //            str = "SELECT isr.ItemName,isr.itemid,'' LedgerTnxID,isr.Quantity RequestedQty,(isr.Quantity-(SUM(IFNULL(ib.Issuevolumn,0))+IFNULL(isr.RejectQty,0))) PendingQty,Patient_Type FROM ipdservices_request isr LEFT JOIN bb_issue_blood ib ON isr.ID=ib.ServiceRequestID WHERE isr.id='" + lblServiceID.Text + "' ";
    //        }
    //        DataTable dt = StockReports.GetDataTable(str);
    //        if (dt.Rows.Count > 0)
    //        {
    //            grdreject.DataSource = dt;
    //            grdreject.DataBind();
    //            mpeReject.Show();
    //        }
    //        else
    //        {
    //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    //        }
    //    }
    //}

    protected void grdSearchList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int index = Convert.ToInt32((e.CommandArgument));

        lblPatientId.Text = ((Label)grdSearchList.Rows[index].FindControl("lblPatientId1")).Text;
        lblTransaction_ID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblTransaction_ID1")).Text;
        lblLedgerTransactionNo.Text = ((Label)grdSearchList.Rows[index].FindControl("lblLedgerTransactionNo1")).Text;
        lblTypeOfTnx.Text = ((Label)grdSearchList.Rows[index].FindControl("lblTnxType1")).Text;
        lblPID.Text = "UHID: " + ((Label)grdSearchList.Rows[index].FindControl("lblPatientId1")).Text;
        lblPName.Text = "Name: " + ((Label)grdSearchList.Rows[index].FindControl("lblName")).Text;
        lblPBloodGroup.Text = "Blood Group: " + ((Label)grdSearchList.Rows[index].FindControl("lblBlood")).Text;
        lblItemID.Text = ((Label)grdSearchList.Rows[index].FindControl("lbItemID")).Text;
        lblQtypending.Text = ((Label)grdSearchList.Rows[index].FindControl("lblQuantity")).Text;
        lblLedgerTnxID.Text = ((Label)grdSearchList.Rows[index].FindControl("lblLedgerTransactionNo1")).Text;
        lblStockID4.Text = ((Label)grdSearchList.Rows[index].FindControl("lblStockID3")).Text;
        if (e.CommandName == "AResult")
        {
            //search1();
            pnlRequest.Visible = true;

            StringBuilder sb2 = new StringBuilder();
            //sb2.Append(" SELECT sm.id,sm.stock_ID,cm.componentname,sm.componentid,(sm.InitialCount-sm.ReleaseCount)InitialCount,sm.bagtype,sm.BloodCollection_Id,sm.BBTubeNo,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,'1' HaveComponent,sm.BloodGroup,DATE_FORMAT(sm.EntryDate,'%d-%b-%Y')EntryDate FROM bb_stock_master sm ");
            //sb2.Append(" inner JOIN  bb_component_master cm ON cm.Id=sm.componentid AND  cm.ID in (SELECT componentid FROM bb_item_component WHERE itemid='" + lblItemID.Text + "' and isactive=1) WHERE sm.IsActive=1  AND sm.ExpiryDate>NOW() And sm.InitialCount>sm.ReleaseCount  AND sm.status=1 AND sm.IsDispatch=0 AND sm.IsDiscarded=0 AND sm.IsHold=0");
            sb2.Append(" SELECT bbc.ServiceRequestID,sm.id,sm.stock_ID,im.TypeName componentname,sm.componentid,(sm.InitialCount-sm.ReleaseCount)InitialCount,sm.bagtype,sm.BloodCollection_Id,bbc.BBTubeNo, ");
            sb2.Append("  DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,'1' HaveComponent,sm.BloodGroup,DATE_FORMAT(sm.EntryDate,'%d-%b-%Y')EntryDate FROM bb_stock_master sm ");
            sb2.Append(" INNER JOIN bb_blood_crossmatch bbc ON bbc.`ComponentID`=sm.componentid ");
            sb2.Append(" INNER JOIN f_itemmaster im ON im.ItemID=bbc.`ItemID` INNER JOIN patient_master pm ON pm.`PatientID`=bbc.`PatientID` ");
            sb2.Append(" WHERE sm.IsActive=1  AND sm.ExpiryDate>NOW() AND sm.InitialCount>sm.ReleaseCount  AND sm.status=1 AND sm.IsDispatch=0 AND sm.IsDiscarded=0 AND sm.IsHold=0 ");
            sb2.Append(" AND im.ItemID='" + lblItemID.Text + "' AND bbc.`Compatiblity`='Compatible' AND bbc.IsActive=1 AND pm.`PatientID`='" + lblPatientId.Text + "' AND sm.Stock_Id='" + lblStockID4.Text + "' GROUP BY im.ItemID ");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            if (dt.Rows.Count > 0)
            {
                grdRequestList.DataSource = dt;
                grdRequestList.DataBind();
                lblStockID.Text = dt.Rows[0]["stock_ID"].ToString();
                pnlTran.Enabled = false;
                //btnShowStock.Enabled = false;
                //btnDispatch.Enabled = false;
                if (dt.Rows[0]["componentid"].ToString() == "1" || dt.Rows[0]["componentid"].ToString() == "2" || dt.Rows[0]["componentid"].ToString() == "3")
                {
                    btnShowStock.Enabled = false;
                    btnDispatch.Enabled = false;
                }
                else
                {
                    btnShowStock.Enabled = false;
                    btnDispatch.Enabled = true;
                }
            }
            else
            {
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                lblMsg.Text = "No Stock Found";
                btnShowStock.Enabled = false;
                btnDispatch.Enabled = false;
            }
        }
        else if (e.CommandName == "Reject")
        {
            //string abc = Util.GetString(e.CommandArgument);
            //string LedTransactionNo = Util.GetString(e.CommandArgument).Split('#')[0];
            //string Item = Util.GetString(e.CommandArgument).Split('#')[1];
            string str = "select ltd.ItemName,ltd.itemid,ltd.LedgerTnxID,ltd.Quantity RequestedQty,(SUM(ltd.Quantity)-(SUM(ltd.BloodIssue)))PendingQty,ltd.`TYPE`  from f_ledgertnxdetail ltd where LedgerTransactionNo='" + lblLedgerTransactionNo.Text + "'AND itemid='" + lblItemID.Text + "' GROUP BY LedgerTransactionNo";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                grdreject.DataSource = dt;
                grdreject.DataBind();
                mpeReject.Show();
            }
        }
    }

    protected void grdTran_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        if (e.CommandName == "ASelect")
        {
            int index1 = Convert.ToInt32(e.CommandArgument);
            lblComponent1.Text = ((Label)grdTran.Rows[index1].FindControl("lblIscomponent")).Text;
            lblLedgerTnxID.Text = ((Label)grdTran.Rows[index1].FindControl("lblLedgerTnxID2")).Text;
            lblItemID.Text = ((Label)grdTran.Rows[index1].FindControl("lblItemID")).Text;
            pnlRequest.Visible = true;
            lblQtypending.Text = ((Label)grdTran.Rows[index1].FindControl("lblQuantity2")).Text;

            if (lblComponent1.Text.ToString() == "1")
            {
                StringBuilder sb2 = new StringBuilder();
                sb2.Append(" SELECT sm.id,sm.stock_ID,cm.componentname,sm.componentid,(sm.InitialCount-sm.ReleaseCount)InitialCount,sm.bagtype,sm.BloodCollection_Id,sm.BBTubeNo,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,'1' HaveComponent,sm.BloodGroup,DATE_FORMAT(sm.EntryDate,'%d-%b-%Y')EntryDate,'0' IsCrossMatch FROM bb_stock_master sm ");
                sb2.Append(" inner JOIN  bb_component_master cm ON cm.Id=sm.componentid AND  cm.ID in (SELECT componentid FROM bb_item_component WHERE itemid='" + lblItemID.Text + "' and isactive=1) WHERE sm.IsActive=1  AND sm.ExpiryDate>NOW() And sm.InitialCount>sm.ReleaseCount  AND sm.status=1 AND sm.IsDispatch=0 AND sm.IsDiscarded=0 AND sm.IsHold=0");
                DataTable dt = StockReports.GetDataTable(sb2.ToString());
                if (dt.Rows.Count > 0)
                {
                    grdRequestList.DataSource = dt;
                    grdRequestList.DataBind();
                    lblStockID.Text = dt.Rows[0]["stock_ID"].ToString();
                    pnlTran.Enabled = false;
                    btnCrossMatch.Enabled = false;
                    //btnShowStock.Enabled = false;
                    //btnDispatch.Enabled = false;
                    if (dt.Rows[0]["componentid"].ToString() == "1" || dt.Rows[0]["componentid"].ToString() == "2" || dt.Rows[0]["componentid"].ToString() == "3")
                    {
                        btnShowStock.Enabled = true;
                        btnDispatch.Enabled = false;
                    }
                    else
                    {
                        btnShowStock.Enabled = true;
                        btnDispatch.Enabled = true;
                    }
                }
                else
                {
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                    lblMsg.Text = "No Stock Found";
                    btnShowStock.Enabled = false;
                    btnDispatch.Enabled = false;
                }
            }
            else
            {
                try
                {
                    BloodProcess bp = new BloodProcess();
                    bp.PatientID = lblPatientId.Text; ;
                    bp.LedgerTnxID = ((Label)grdTran.Rows[index1].FindControl("lblLedgerTnxID2")).Text;
                    bp.ItemID = ((Label)grdTran.Rows[index1].FindControl("lblItemID")).Text; ;
                    bp.ProsessBy = Session["ID"].ToString();
                    bp.Qtypending = Util.GetDecimal(((Label)grdTran.Rows[index1].FindControl("lblQuantity2")).Text);
                    bp.CentreId = Util.GetInt(Session["CentreID"].ToString());
                    bp.Insert();
                    string up2 = "UPDATE f_ledgertnxdetail SET BloodIssue=Quantity where LedgerTnxID='" + lblLedgerTnxID.Text + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);
                    Tranx.Commit();
                    txtPatientName.Text = "";
                    txtReason.Text = "";
                    txtRegNo.Text = "";
                    txtIPDNo.Text = "";
                    pnlSearch.Visible = false;
                    pnlRequest.Visible = false;
                    grdRequestList.DataSource = null;
                    grdRequestList.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM205','" + lblMsg.ClientID + "');", true);
                    search1();
                    if (grdTran.Rows.Count == 0)
                    {
                        search("");
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    Tranx.Rollback();

                    return;
                }
                finally
                {
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            //getRequest(index1);
        }
        else if (e.CommandName == "Areject")
        {
            string abc = Util.GetString(e.CommandArgument);
            string LedTransactionNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string Item = Util.GetString(e.CommandArgument).Split('#')[1];
            string str = "select ltd.ItemName,ltd.itemid,ltd.LedgerTnxID,ltd.Quantity RequestedQty,(SUM(ltd.Quantity)-(SUM(ltd.BloodIssue)))PendingQty,ltd.TYPE  from f_ledgertnxdetail ltd where LedgerTransactionNo='" + LedTransactionNo + "'AND itemid='" + Item + "' GROUP BY LedgerTransactionNo";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                grdreject.DataSource = dt;
                grdreject.DataBind();
                mpeReject.Show();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

                search1();
            }
        }
        //GridEnable();
    }

    protected void GridEnable()
    {
        foreach (GridViewRow gr in grdRequestList.Rows)
        {
            if (((CheckBox)gr.FindControl("chkYes")).Checked)
            {
                gr.Cells[6].Enabled = true;
                //btnShowStock.Enabled = true;
                //btnDispatch.Enabled = true;
            }
            else
            {
                gr.Cells[6].Enabled = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientName.Focus();
            txtfromdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            CreateTable();
            ViewState.Add("dtItem", dtItem);
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["CentreID"] = Session["CentreID"].ToString();
            BindBloodGroup();
        }
        txtfromdate.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    private void BindBloodGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,BloodGroup FROM bb_bloodgroup_master WHERE isactive=1");
        ddlBloodGroup.DataSource = dt;
        ddlBloodGroup.DataTextField = "BloodGroup";
        ddlBloodGroup.DataValueField = "id";
        ddlBloodGroup.DataBind();
    }

    private void getRequest(int index1)
    {
        //foreach (GridViewRow gr in grdTran.Rows)
        //{
        //    if (gr.RowIndex != index1)
        //    {
        //        gr.Visible = false;
        //    }
        //}
        //pnlRequest.Visible = true;
        //StringBuilder sb2 = new StringBuilder();
        //sb2.Append(" SELECT sm.id,sm.stock_ID,cm.componentname,(sm.InitialCount-sm.ReleaseCount)InitialCount,sm.bagtype,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%y')ExpiryDate FROM bb_component_master cm ");
        //sb2.Append(" INNER JOIN  bb_stock_master sm ON cm.Id=sm.componentid WHERE sm.IsActive=1  AND sm.ExpiryDate>NOW() And sm.InitialCount>sm.ReleaseCount AND  cm.ID=1 ");
        //DataTable dt = StockReports.GetDataTable(sb2.ToString());
        //if (dt.Rows.Count > 0)
        //{
        //    grdRequestList.DataSource = dt;
        //    grdRequestList.DataBind();
        //    pnlTran.Enabled = false;
        //    //lblInitialcount1.Text = dt.Rows[0]["InitialCount"].ToString();
        //}
        //else
        //    lblMsg.Text = "No Stock Found";
    }

    private void search(string ReportType)
    {
        try
        {
            Label1.Visible = false;
            txtReason.Visible = false;
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT t.ServiceRequestID, (Select TransNo from Patient_medical_history where PatientID=t.PatientID limit 1)as TransNo,pm.BloodGroup,pm.PName PatientName,pm.Age,pm.Gender,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.State,' ',pm.City,' ', pm.Country,' ',pm.Pincode)Address,  t.DATE,SubCategory,ItemName,Rate,Quantity,GrossAmt,Disc,NetAmt,t.ItemID,Qty,TnxType,t.BloodStockID,   ");
            sb.Append("  t.TransactionID,t.PatientID,LedgerTransactionNo,Type_ID, (SELECT bed_no FROM room_master WHERE roomid=(SELECT roomid FROM patient_ipd_profile WHERE TransactionID=t.TransactionID LIMIT 1))bed_no, ");//IF(t.TransactionID LIKE 'ISHHI%',t.TransactionID,'')Transaction_ID
            sb.Append("  (SELECT NAME FROM ipd_case_type_Master WHERE IPDCaseTypeID=(SELECT IPDCaseTypeID FROM patient_ipd_profile WHERE TransactionID=t.TransactionID LIMIT 1))Name, (SELECT NAME FROM doctor_master WHERE doctorid=( ");
            sb.Append("  SELECT doctorid FROM `patient_medical_history` WHERE patientid=t.patientid LIMIT 1))DNAME   FROM (   SELECT bc.`ServiceRequestID`,(SELECT BloodIssue FROM f_ledgertnxdetail WHERE ItemID=bc.`ItemID` AND LedgerTransactionNo=bc.`LedgerTnxNo` LIMIT 1) BloodIssue, DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE, Lt.LedgerTransactionNo,lt.TransactionID,lt.PatientID,IFNULL((SELECT imm.TypeName FROM f_itemmaster imm WHERE imm.ItemID=bc.`ItemID`),'') ItemName,bc.`ItemID`,(ltd.Quantity-ltd.BloodIssue)Qty,bc.BloodStockID, ");
            sb.Append("  sc.Name SubCategory, 	IFNULL(im.Type_ID,'')Type_ID,ltd.Rate,(SUM(ltd.Quantity)-SUM(ltd.BloodIssue))Quantity,         LT.GrossAmount    GrossAmt,((ltd.Rate*ltd.Quantity)-ltd.Amount)Disc,LT.NetAmount    NetAmt, ");
            sb.Append("  IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD',IF(lt.TypeOfTnx='Emergency','EMG','IPD'))TnxType FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON  	lt.LedgerTransactionNo = ltd.LedgerTransactionNo  INNER JOIN `patient_master` pm ON pm.`PatientID`=lt.`PatientID` INNER JOIN `patient_medical_history` pmh ON pmh.`PatientID`=pm.`PatientID`  ");
            sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID  INNER JOIN f_itemmaster im ON im.SubCategoryID = sc.SubCategoryID INNER JOIN bb_blood_crossmatch bc ON bc.LedgerTnxNo=ltd.`LedgerTransactionNo`  WHERE   ");
            sb.Append("  IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure') ,lt.IsCancel=0,ltd.IsVerified=1 	)  AND UCASE(sc.DisplayName)='BLOOD BANK'  ");
            if (txtIPDNo.Text == "" && txtRegNo.Text == "" && txtPatientName.Text == "")
            {
                if (txtfromdate.Text != "")
                {
                    sb.Append(" AND DATE(lt.Date) >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (txtdateTo.Text != "")
                {
                    sb.Append(" AND DATE(lt.Date) <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'  ");
                }
            }
            if (txtIPDNo.Text != "")
            {
                //sb.Append(" AND ltd.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
                sb.Append(" AND pmh.TransNo=" + txtIPDNo.Text.Trim() + " AND pmh.Type='IPD' ");
            }
            if (txtRegNo.Text != "")
            {
                sb.Append(" AND lt.PatientID= '" + txtRegNo.Text + "'");
            }
            if (rdbType.SelectedValue != "All")
            {
                if (rdbType.SelectedValue == "OPD")
                {
                    sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='OPD' ");
                }
                //else if (rdbType.SelectedValue == "EMG")
                //{
                //    sb.Append(" AND lt.TypeOfTnx IN ('IPD-Billing') AND pmh.Type='EMG' ");
                //}
                else if (rdbType.SelectedValue == "IPD")
                {
                    sb.Append(" AND lt.TypeOfTnx IN ('IPD-Billing') ");//IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='IPD'
                }
                else if (rdbType.SelectedValue == "EMG")
                {
                    sb.Append(" AND lt.TypeOfTnx IN ('Emergency') ");
                }
            }

            sb.Append(" AND bc.IsActive=1 AND bc.Compatiblity='Compatible'  GROUP BY lt.`LedgertransactionNo`, bc.ItemID )t INNER JOIN patient_master pm ON pm.PatientID = t.PatientID ");
            //sb.Append(" INNER JOIN  bb_blood_crossmatch bbc ON bbc.LedgerTnxNo=t.LedgerTransactionNo AND bbc.IsActive=1 AND bbc.Compatiblity='Compatible' "); //

            sb.Append(" WHERE t.Quantity>0 AND t.`BloodIssue`=0 ");
            if (txtPatientName.Text != "")
            {
                sb.Append(" AND pm.PName  like '" + txtPatientName.Text + "%'");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                if (ReportType == "")
                {
                    grdSearchList.DataSource = dt;
                    grdSearchList.DataBind();
                    grdSearchList.Enabled = true;
                    pnlSearch.Visible = true;
                    grdRequestList.DataSource = null;
                    grdRequestList.DataBind();
                    grdTran.DataSource = null;
                    pnlRequest.Visible = false;
                    grdTran.DataBind();
                }
                else
                {
                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "PENDING REQUEST REPORT";
                    Session["Period"] = "From " + Util.GetDateTime(txtfromdate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtdateTo.Text).ToString("dd-MMM-yyyy");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
                    //lblMsg.Visible = false;
                }
            }
            else
            {
                grdSearchList.DataSource = null;
                grdSearchList.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            grdSearchList.DataSource = null;
            grdSearchList.DataBind();
        }
    }


    /********************************commented by *************************************************/
    //private void search(string ReportType)
    //{
    //    try
    //    {
    //        Label1.Visible = false;
    //        lblMsg.Text = "";
    //        txtReason.Visible = false;
    //        StringBuilder sb = new StringBuilder();
    //        if (rdbType.SelectedValue == "OPD" || rdbType.SelectedValue == "All")
    //        {
    //            sb.Append(" SELECT '' Compatiblity,'' EmergencyNo,''CrossMatchQty,''ServiceID,'' IPDCaseTypeId,'' PanelID,pm.BloodGroup,pm.PName PatientName,pm.Age,pm.Gender,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.State,' ',pm.City,' ', pm.Country,' ',pm.Pincode)Address,  t.DATE,LedgerTransactionNo,LedgerTnxID,IF(t.TransactionID LIKE 'ISHHI%',t.TransactionID,'')TransactionID,t.PatientID,ItemName,SubCategory,Disc,NetAmt,GrossAmt,TnxType   ");
    //            sb.Append("  , (SELECT bed_no FROM room_master WHERE roomid=(SELECT roomid FROM patient_ipd_profile WHERE TransactionID=t.TransactionID LIMIT 1))bed_no, ");
    //            sb.Append("  (SELECT NAME FROM ipd_case_type_Master WHERE IPDCaseTypeID=(SELECT IPDCaseTypeID FROM patient_ipd_profile WHERE TransactionID=t.TransactionID LIMIT 1))Name, (SELECT NAME FROM doctor_master WHERE DoctorID=( ");
    //            sb.Append("  SELECT DoctorID FROM `patient_medical_history` WHERE PatientID=t.PatientID LIMIT 1))DNAME,'' ReserveDate,Type_ID ,t.ItemID,Quantity,IssueQty,RejectQty,PendingQuantity,'' Iscomponent, ");

    //            sb.Append(" (SELECT deptname FROM f_rolemaster WHERE id=t.roleid ) AS department ");

    //            sb.Append("  FROM (   SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE, Lt.LedgerTransactionNo,ltd.LedgerTnxID,lt.TransactionID,lt.PatientID,ltd.ItemName, ");
    //            sb.Append("  sc.Name SubCategory, 	IFNULL(im.Type_ID,'')Type_ID,SUM(ltd.Quantity)Quantity,(SUM(ltd.Quantity)-SUM(ltd.BloodIssue))PendingQuantity, 0 RejectQty,0 IssueQty,LT.GrossAmount AS GrossAmt,'0 'Disc,LT.NetAmount    NetAmt, ");
    //            sb.Append("  IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')TnxType,ltd.ItemID , ltd.roleid   ");

    //            sb.Append("  FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON  	lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
    //            sb.Append("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID  INNER JOIN f_itemmaster im ON im.SubCategoryID = sc.SubCategoryID  AND ltd.ItemID=im.ItemID WHERE   ");
    //            sb.Append("  IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure') ,lt.IsCancel=0,ltd.IsVerified=1 	)  AND UCASE(sc.DisplayName)='BLOOD BANK' and ltd.centreID='" + ViewState["CentreID"].ToString() + "' ");
    //            if (txtIPDNo.Text == "" && txtRegNo.Text == "" && txtPatientName.Text == "")
    //            {
    //                if (txtfromdate.Text != "")
    //                {
    //                    sb.Append(" AND DATE(lt.Date) >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + "'");
    //                }
    //                if (txtdateTo.Text != "")
    //                {
    //                    sb.Append(" AND DATE(lt.Date) <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'  ");
    //                }
    //            }
    //            if (txtIPDNo.Text != "")
    //            {
    //                sb.Append(" AND ltd.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
    //               // sb.Append(" AND pmh.TransNo=" + txtIPDNo.Text.Trim() + " ");
    //            }
    //            if (txtRegNo.Text != "")
    //            {
    //                sb.Append(" AND lt.PatientID= '" + txtRegNo.Text + "'");
    //            }
    //            if (rdbType.SelectedValue != "All")
    //            {
    //                if (rdbType.SelectedValue == "OPD")
    //                {
    //                    sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='OPD' ");
    //                }
    //                else
    //                {
    //                    sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='IPD' ");
    //                }
    //            }

    //            sb.Append("  GROUP BY LedgerTnxID )t INNER JOIN patient_master pm ON pm.PatientID = t.PatientID ");

    //            sb.Append(" WHERE t.PendingQuantity>0 ");
    //            if (txtPatientName.Text != "")
    //            {
    //                sb.Append(" AND pm.PName  like '" + txtPatientName.Text + "%'");
    //            }
    //        }
    //        if (rdbType.SelectedValue == "All")
    //        {
    //            sb.Append(" Union All ");
    //        }
    //        if (rdbType.SelectedValue == "IPD" || rdbType.SelectedValue == "All")
    //        {
    //            sb.Append(" SELECT bcm.Compatiblity,'' EmergencyNo,COUNT(bcm.BloodStockID)CrossMatchQty, isr.id ServiceID,icm.IPDCaseTypeId,isr.PanelID, pm.BloodGroup,pm.PName PatientName,pm.Age,pm.Gender,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.State,' ',pm.City,' ', pm.Country,' ',pm.Pincode)Address, ");
    //            sb.Append(" DATE_FORMAT(isr.EntryDate,'%d-%b-%Y')DATE,''LedgerTransactionNo,''LedgerTnxID, IF(isr.TransactionID LIKE 'ISHHI%',isr.TransactionID,'')TransactionID,isr.PatientID AS PatientID,isr.ItemName,'BloodBank' SubCategory, ");
    //            sb.Append(" ((isr.Rate*isr.Quantity)-isr.Amount)Disc,(isr.Rate*isr.Quantity)NetAmt,(isr.Rate*isr.Quantity)GrossAmt,'IPD' AS TnxType,CONCAT(rm.Name,'/',rm.Bed_No)Bed_No,icm.Name,CONCAT(dm.Title,'',dm.Name)Dname,CONCAT(DATE_FORMAT(isr.ServiceDate,'%d-%b-%Y'),' ',DATE_FORMAT(isr.Servicetime,'%h:%i %p'))ReserveDate ");
    //            sb.Append(" ,'' Type_ID,isr.ItemID,isr.Quantity,IFNULL((SELECT SUM(issuevolumn) FROM bb_issue_blood WHERE ServiceRequestID=isr.ID AND ishold=0 AND isactive=1),0)IssueQty, IFNULL(isr.RejectQty,0)RejectQty,(isr.Quantity-(IFNULL((SELECT SUM(issuevolumn) FROM bb_issue_blood WHERE ServiceRequestID=isr.ID AND ishold=0 AND isactive=1),0)+IFNULL(isr.RejectQty,0) ");
    //            sb.Append(" ))PendingQuantity,IF(IFNULL((SELECT  ComponentID FROM bb_item_component WHERE ItemID=isr.ItemID LIMIT 1),0)=0,'0','1')Iscomponent,    ");

    //            sb.Append(" (SELECT deptname FROM f_rolemaster WHERE id=isr.roleid ) AS department     ");

    //            sb.Append("  FROM ipdservices_request isr ");
    //            sb.Append(" INNER JOIN patient_ipd_profile pip  ON isr.TransactionID=pip.TransactionID ");
    //            sb.Append(" LEFT JOIN bb_blood_CrossMatch bcm ON bcm.ServiceRequestID=isr.ID AND bcm.IsUnReserved=0 and UCASE(bcm.Compatiblity)<>'UNCOMPATIBLE'");
    //            sb.Append(" INNER JOIN ( SELECT MAX(p.PatientIPDProfile_ID)PatientIPDProfile_ID FROM patient_ipd_profile p INNER JOIN ipdservices_request ir ON ir.TransactionID=p.TransactionID ");
    //            sb.Append(" WHERE  ir.Type='BB' AND ir.Patient_Type='IPD' AND ir.CentreID='" + ViewState["CentreID"].ToString() + "' AND ir.EntryDate >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND ir.EntryDate <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
    //            sb.Append(" GROUP BY p.TransactionID )p ON p.PatientIPDProfile_ID=pip.PatientIPDProfile_ID ");
    //            sb.Append(" inner JOIN room_master rm ON rm.RoomId=pip.RoomID ");
    //            sb.Append(" inner JOIN ipd_case_type_master icm ON rm.IPDCaseTypeID=icm.IPDCaseTypeID INNER JOIN patient_master pm ON isr.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID=isr.DoctorID WHERE  isr.Type='BB' and isr.Patient_Type='IPD' AND isr.CentreID='" + ViewState["CentreID"].ToString() + "' ");
    //            if (txtIPDNo.Text == "" && txtRegNo.Text == "" && txtPatientName.Text == "")
    //            {
    //                if (txtfromdate.Text != "")
    //                {
    //                    sb.Append(" AND isr.EntryDate >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
    //                }
    //                if (txtdateTo.Text != "")
    //                {
    //                    sb.Append(" AND isr.EntryDate <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
    //                }
    //            }
    //            if (txtIPDNo.Text != "")
    //            {
    //                sb.Append(" AND isr.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
    //            }
    //            if (txtRegNo.Text != "")
    //            {
    //                sb.Append(" AND isr.PatientID= '" + txtRegNo.Text + "'");
    //            }
    //            if (txtPatientName.Text != "")
    //            {
    //                sb.Append(" AND pm.PName  like '" + txtPatientName.Text + "%'");
    //            }
    //            sb.Append(" GROUP BY isr.ID ");
    //        }
    //        if (rdbType.SelectedValue == "All")
    //        {
    //            sb.Append(" Union All ");
    //        }
    //        if (rdbType.SelectedValue == "EMG" || rdbType.SelectedValue == "All")
    //        {
    //            sb.Append(" SELECT bcm.Compatiblity, isr.EmergencyNo,COUNT(bcm.BloodStockID)CrossMatchQty, isr.id ServiceID,icm.IPDCaseTypeId,isr.PanelID, pm.BloodGroup,pm.PName PatientName,pm.Age,pm.Gender,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.State,' ',pm.City,' ', pm.Country,' ',pm.Pincode)Address, ");
    //            sb.Append(" DATE_FORMAT(isr.EntryDate,'%d-%b-%Y')DATE,''LedgerTransactionNo,''LedgerTnxID, isr.TransactionID TransactionID,isr.PatientID AS PatientID,isr.ItemName,'BloodBank' SubCategory, ");
    //            sb.Append(" ((isr.Rate*isr.Quantity)-isr.Amount)Disc,(isr.Rate*isr.Quantity)NetAmt,(isr.Rate*isr.Quantity)GrossAmt,'EMG' AS TnxType,CONCAT(rm.Name,'/',rm.Bed_No)Bed_No,icm.Name,CONCAT(dm.Title,'',dm.Name)Dname,CONCAT(DATE_FORMAT(isr.ServiceDate,'%d-%b-%Y'),' ',DATE_FORMAT(isr.Servicetime,'%h:%i %p'))ReserveDate ");
    //            sb.Append(" ,'' Type_ID,isr.ItemID,isr.Quantity,IFNULL((SELECT SUM(issuevolumn) FROM bb_issue_blood WHERE ServiceRequestID=isr.ID AND ishold=0 AND isactive=1),0)IssueQty, IFNULL(isr.RejectQty,0)RejectQty, ");
    //            sb.Append(" (isr.Quantity-(IFNULL((SELECT SUM(issuevolumn) FROM bb_issue_blood WHERE ServiceRequestID=isr.ID AND ishold=0 AND isactive=1),0)+ifnull(isr.RejectQty,0)))PendingQuantity,IF(IFNULL((SELECT  ComponentID FROM bb_item_component WHERE ItemID=isr.ItemID LIMIT 1),0)=0,'0','1')Iscomponent,   ");

    //            sb.Append(" (SELECT deptname FROM f_rolemaster WHERE id=isr.roleid ) AS department  ");
                
    //           sb.Append(" FROM ipdservices_request isr ");
    //            sb.Append(" LEFT JOIN bb_blood_CrossMatch bcm ON bcm.ServiceRequestID=isr.ID AND bcm.IsUnReserved=0 and UCASE(bcm.Compatiblity)<>'UNCOMPATIBLE' INNER JOIN Emergency_Patient_Details epd ON isr.TransactionID=epd.TransactionId left JOIN room_master rm ON rm.RoomId=epd.RoomID ");
    //            sb.Append(" left JOIN ipd_case_type_master icm ON rm.IPDCaseTypeID=icm.IPDCaseTypeID INNER JOIN patient_master pm ON isr.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID=isr.DoctorID WHERE  isr.Type='BB' and isr.Patient_Type='EMG' AND isr.CentreID='" + ViewState["CentreID"].ToString() + "' ");
    //            if (txtIPDNo.Text == "" && txtRegNo.Text == "" && txtPatientName.Text == "")
    //            {
    //                if (txtfromdate.Text != "")
    //                {
    //                    sb.Append(" AND isr.EntryDate >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
    //                }
    //                if (txtdateTo.Text != "")
    //                {
    //                    sb.Append(" AND isr.EntryDate <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
    //                }
    //            }
    //            if (txtIPDNo.Text != "")
    //            {
    //                sb.Append(" AND isr.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
    //            }
    //            if (txtRegNo.Text != "")
    //            {
    //                sb.Append(" AND isr.PatientID= '" + txtRegNo.Text + "'");
    //            }
    //            if (txtPatientName.Text != "")
    //            {
    //                sb.Append(" AND pm.PName  like '" + txtPatientName.Text + "%'");
    //            }
    //            sb.Append(" GROUP BY isr.ID ");
    //        }
    //        DataTable dt = StockReports.GetDataTable(sb.ToString());
    //        if (dt.Rows.Count > 0)
    //        {
    //            if (ReportType == "")
    //            {
    //                grdSearchList.DataSource = dt;
    //                grdSearchList.DataBind();
    //                grdSearchList.Enabled = true;
    //                pnlSearch.Visible = true;
    //                grdRequestList.DataSource = null;
    //                grdRequestList.DataBind();
    //                pnlTran.Visible = false;
    //                grdTran.DataSource = null;
    //                pnlRequest.Visible = false;
    //                grdTran.DataBind();
    //                ViewState["dtRquest"] = dt;
    //            }
    //            else
    //            {
    //                dt.Columns.Remove("ServiceID");
    //                dt.Columns.Remove("IPDCaseTypeId");
    //                dt.Columns.Remove("PanelID");
    //                dt.Columns.Remove("LedgerTransactionNo");
    //                dt.Columns.Remove("LedgerTnxID");
    //                dt.Columns.Remove("TransactionID");
    //                dt.Columns.Remove("Disc");
    //                dt.Columns.Remove("NetAmt");
    //                dt.Columns.Remove("GrossAmt");
    //                dt.Columns.Remove("ItemID");
    //                dt.Columns.Remove("Iscomponent");
    //                dt.Columns.Remove("Type_ID");

    //                Session["dtExport2Excel"] = dt;
    //                Session["ReportName"] = "PENDING REQUEST REPORT";
    //                Session["Period"] = "From " + Util.GetDateTime(txtfromdate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtdateTo.Text).ToString("dd-MMM-yyyy");
    //                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
    //                //lblMsg.Visible = false;
    //            }
    //        }
    //        else
    //        {
    //            grdSearchList.DataSource = null;
    //            grdSearchList.DataBind();
    //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog c1 = new ClassLog();
    //        c1.errLog(ex);
    //        grdSearchList.DataSource = null;
    //        grdSearchList.DataBind();
    //    }
    //}

    /*******************************************END****************************************************/

    //private void search(string ReportType)
    //{
    //    try
    //    {
    //        Label1.Visible = false;
    //        txtReason.Visible = false;
    //        StringBuilder sb = new StringBuilder();
    //        sb.Append("Select * from ( ");
    //        sb.Append("  SELECT '' IsCrossMatch,''bed_no,''NAME ,CONCAT(dm.Title,'',dm.Name)DNAME,''ServiceID,lt.PanelID PanelID,'' IPDCaseType_Id,ltd.ItemID,'' Iscomponent,'' PendingQuantity,'' ReserveDate , ");
    //        sb.Append(" DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE, Lt.LedgerTransactionNo, IF(lt.TransactionID LIKE 'ISHHI%',lt.TransactionID,'')TransactionID ,lt.PatientID,pm.BloodGroup,pm.PName PatientName,pm.Age, ");
    //        sb.Append(" pm.Gender,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.State,' ',pm.City,' ', pm.Country,' ',pm.Pincode)Address,ltd.ItemName,'BLOOD BANK' SubCategory, ");
    //        sb.Append(" '' Type_ID,ltd.Rate,(SUM(ltd.Quantity)-SUM(ltd.BloodIssue))Quantity,         LT.GrossAmount    GrossAmt,((ltd.Rate*ltd.Quantity)-ltd.Amount)Disc, ");
    //        sb.Append(" LT.NetAmount    NetAmt,  'OPD' TnxType 	FROM f_ledgertransaction lt  	INNER JOIN f_ledgertnxdetail ltd ON  	lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
    //        sb.Append(" INNER JOIN doctor_master dm ON ltd.DoctorID=dm.DoctorID 	INNER JOIN patient_master pm ON pm.PatientID = lt.PatientID    ");
    //        sb.Append(" WHERE lt.IsCancel=0 	AND lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING') and ltd.centreID='" + Session["CentreID"].ToString() + "'  ");
    //        if (txtIPDNo.Text == "" && txtRegNo.Text == "" && txtPatientName.Text == "")
    //        {
    //            if (txtfromdate.Text != "")
    //            {
    //                sb.Append(" and lt.Date >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
    //            }
    //            if (txtdateTo.Text != "")
    //            {
    //                sb.Append(" and lt.Date <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
    //            }
    //        }
    //        sb.Append(" GROUP BY LedgerTransactionNo ");
    //        sb.Append(" UNION ALL ");
    //        sb.Append(" SELECT IF(IFNULL(bcm.BloodStockID,'0')='0',0,1)IsCrossMatch, isr.id ServiceID,icm.IPDCaseType_Id,isr.PanelID, pm.BloodGroup,pm.PName PatientName, ");
    //        sb.Append(" pm.Age,pm.Gender,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.State,' ',pm.City,' ', pm.Country,' ',pm.Pincode)Address,  DATE_FORMAT(isr.EntryDate,'%d-%b-%Y')DATE,");
    //        sb.Append(" ''LedgerTransactionNo, IF(isr.TransactionID LIKE 'ISHHI%',isr.TransactionID,'')TransactionID,isr.PatientID AS PatientID, ");
    //        sb.Append(" isr.ItemName,'BloodBank' SubCategory,  ((isr.Rate*isr.Quantity)-isr.Amount)Disc,(isr.Rate*isr.Quantity)NetAmt,(isr.Rate*isr.Quantity)GrossAmt, ");
    //        sb.Append(" 'IPD' AS TnxType,CONCAT(rm.Name,'/',rm.Bed_No)Bed_No,icm.Name,CONCAT(dm.Title,'',dm.Name)Dname,DATE_FORMAT(isr.ServiceDate,'%d-%b-%Y')ReserveDate  , ");
    //        sb.Append(" '' Type_ID,isr.ItemID,isr.Quantity, ");
    //        sb.Append(" (isr.Quantity-IFNULL((SELECT SUM(issuevolumn) FROM bb_issue_blood WHERE ServiceRequestID=isr.ID AND ishold=0),0))PendingQuantity, ");
    //        sb.Append(" IF(IFNULL((SELECT  ComponentID FROM bb_item_component WHERE ItemID=isr.ItemID LIMIT 1),0)=0,'0','1')Iscomponent,isr.rate  ");
    //        sb.Append(" FROM ipdservices_request isr  LEFT JOIN bb_blood_CrossMatch bcm ON bcm.ServiceRequestID=isr.ID 	INNER JOIN patient_ipd_profile pip ON isr.TransactionID=pip.TransactionID  ");
    //        sb.Append(" INNER JOIN room_master rm ON rm.Room_Id=pip.Room_ID  INNER JOIN ipd_case_type_master icm ON rm.IPDCaseTypeID=icm.IPDCaseType_ID INNER JOIN patient_master pm ON isr.PatientID=pm.PatientID INNER JOIN doctor_master dm ON dm.DoctorID=isr.DoctorID  ");
    //        sb.Append(" WHERE  isr.Type='BB'   AND isr.centreID='"+Session["CentreID"].ToString()+"'	 ");
    //        if (txtIPDNo.Text == "" && txtRegNo.Text == "" && txtPatientName.Text == "")
    //        {
    //            if (txtfromdate.Text != "")
    //            {
    //                sb.Append(" and isr.EntryDate >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
    //            }
    //            if (txtdateTo.Text != "")
    //            {
    //                sb.Append(" and isr.EntryDate <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
    //            }
    //        }
    //        sb.Append(" GROUP BY isr.id            ");
    //        sb.Append(" )t   ");

    //        if (txtIPDNo.Text != "")
    //        {
    //            sb.Append(" AND t.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
    //        }
    //        if (txtRegNo.Text != "")
    //        {
    //            sb.Append(" AND t.PatientID= '" + txtRegNo.Text + "'");
    //        }
    //        if (txtPatientName.Text != "")
    //        {
    //            sb.Append(" AND t.PName  like '" + txtPatientName.Text + "%'");
    //        }
    //        DataTable dt = StockReports.GetDataTable(sb.ToString());
    //        if (dt.Rows.Count > 0)
    //        {
    //            if (ReportType == "")
    //            {
    //                grdSearchList.DataSource = dt;
    //                grdSearchList.DataBind();
    //                grdSearchList.Enabled = true;
    //                pnlSearch.Visible = true;
    //                grdRequestList.DataSource = null;
    //                grdRequestList.DataBind();
    //                pnlTran.Visible = false;
    //                grdTran.DataSource = null;
    //                pnlRequest.Visible = false;
    //                grdTran.DataBind();
    //                ViewState["dtRquest"] = dt;
    //            }
    //            else
    //            {
    //                Session["dtExport2Excel"] = dt;
    //                Session["ReportName"] = "PENDING REQUEST REPORT";
    //                Session["Period"] = "From " + Util.GetDateTime(txtfromdate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtdateTo.Text).ToString("dd-MMM-yyyy");
    //                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
    //                //lblMsg.Visible = false;
    //            }
    //        }
    //        else
    //        {
    //            grdSearchList.DataSource = null;
    //            grdSearchList.DataBind();
    //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog c1 = new ClassLog();
    //        c1.errLog(ex);
    //        grdSearchList.DataSource = null;
    //        grdSearchList.DataBind();
    //    }
    //}

    private void search1()
    {
        try
        {
            Label1.Visible = true;
            txtReason.Visible = true;
            StringBuilder sb2 = new StringBuilder();
            sb2.Append("  SELECT * FROM (   SELECT t.LedgerTnxID,t.LedgerTransactionNo, t.ItemID,t.ItemName,SUM(t.QTY) Quantity,t.Rate,t.DiscAmt");
            sb2.Append("   ,t.Amount,IF(IFNULL((SELECT  ComponentID FROM bb_item_component WHERE ItemID=t.ItemID LIMIT 1),0)=0,'0','1')Iscomponent FROM (        ");
            sb2.Append("   SELECT (ltd.Quantity-ltd.BloodIssue)Qty,ltd.LedgerTnxID, ltd.ItemID,ltd.ItemName,ltd.Rate,ltd.DiscAmt,ltd.Amount,ltd.LedgerTransactionNo     ");
            sb2.Append("     FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=ltd.SubCategoryID   ");
            sb2.Append("    INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID  AND UPPER(scm.DisplayName)='BLOOD BANK'  WHERE ltd.LedgerTransactionNo='" + lblLedgerTransactionNo.Text + "'  ");
            sb2.Append("         )t      GROUP BY t.LedgerTransactionNo,t.ItemID)T1     WHERE T1.Quantity>0; ");

            DataTable dt1 = StockReports.GetDataTable(sb2.ToString());
            if (dt1.Rows.Count > 0)
            {
                grdTran.DataSource = dt1;
                grdTran.DataBind();
                pnlTran.Visible = true;
                pnlTran.Enabled = true;
                pnlSearch.Visible = false;
            }
            else
            {
                grdTran.DataSource = null;
                grdTran.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

                pnlTran.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }

    protected void btnCrossMatch_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        int isBilling = 0;
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (lblBloodGroup.Text.Trim() == "")
            {
                lblMsg.Text = "Please Update Blood Group of Patient";
                return;
            }
            int IssueQty = 0, chkCompatiblity = 0;
            string IssueId = string.Empty;
            foreach (GridViewRow gr in grdRequestList.Rows)
            {
                if (((CheckBox)gr.FindControl("chkYes")).Checked)
                {

                    if (((DropDownList)gr.FindControl("ddlCompatibility")).SelectedIndex == 0)
                    {
                        chkCompatiblity = chkCompatiblity + 1;
                    }
                    if (((Label)gr.FindControl("lblisCrosschargesapply")).Text == "1")
                    {
                        if (Util.GetString(((DropDownList)gr.FindControl("ddlCompatibility")).SelectedValue) != "UnCompatible")
                        {
                            isBilling = 1;
                            IssueQty = IssueQty + 1;
                        }
                    }
                    else
                    {
                        IssueQty = IssueQty + 1;
                    }
                }

            }
            if (IssueQty <= 0)
            {
                lblMsg.Text = "Please Select At least One BAG";
                return;
            }
            decimal record = Util.GetDecimal(lblQtypending.Text.Replace("Pending Qty :", "").Trim());
            if (IssueQty > record)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM206','" + lblMsg.ClientID + "');", true);

                return;
            }
            if (chkCompatiblity > 0)
            {
                lblMsg.Text = "Please Select Compatiblity of Selected Bag";
                return;
            }

            DataTable dtServiceDetail = StockReports.GetDataTable("Select * from ipdservices_request where id='" + lblServiceID.Text + "'");

            // Insert a Single Item Cross Match 
            string PanelID = lblPanelID.Text.Trim();
            string IPDCaseType_ID = lblIPDCaseType_Id.Text;
            string TID = lblTransaction_ID.Text;
            string PID = lblPatientId.Text.Trim();
            string Ref_Code = StockReports.ExecuteScalar(" SELECT ReferenceCode FROM f_panel_master WHERE PanelID='" + lblPanelID.Text + "' AND isactive=1 ");
            

            string ItemID = "LSHHI19586"; // CrossMatch Charge ItemID
            string ScheduleCHargeID = StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE panelId='" + Ref_Code + "' AND isdefault=1 ");
            string PatientType = StockReports.ExecuteScalar("Select PMH.Patient_Type from patient_medical_history pmh where pmh.TransactionID='" + lblTransaction_ID.Text.Trim() + "'");
            DataTable dtTemp = new DataTable();

            var ledgerTransactionNo = string.Empty;
            var isEmergencyPatient = dtServiceDetail.Rows[0]["Patient_Type"].ToString().ToUpper() == "EMG" ? true : false;

            if (isEmergencyPatient)
                dtTemp = StockReports.GetDataTable("select im.SubCategoryID,im.TypeName item,con.ConfigID, (IFNULL(rt.Rate,0))Rate,rt.ScheduleChargeID,rt.ID,IFNULL(rt.ItemCode,'')ItemCode,IFNULL(rt.ItemDisplayName,'')ItemDisplayName  from f_ratelist rt INNER JOIN f_itemmaster im ON im.ItemID=rt.ItemID INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID INNER JOIN  f_categorymaster c ON  c.CategoryID=sm.CategoryID INNER JOIN f_configrelation con ON c.CategoryID=con.CategoryID  INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rt.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID where rt.ItemID='" + ItemID + "' and rt.PanelID=" + Ref_Code + " and IsCurrent=1 and rt.CentreID='" + Session["CentreID"].ToString() + "'");
            else
                dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + ItemID + "'", Ref_Code, IPDCaseType_ID, ScheduleCHargeID, ViewState["CentreID"].ToString());



            CreateTable();
            if (dtTemp != null && dtTemp.Rows.Count > 0)
            {

                DataRow dr = dtItem.NewRow();
                dr["Category"] = StockReports.ExecuteScalar("SELECT cm.Name FROM f_categorymaster cm INNER JOIN f_subcategorymaster sc ON cm.CategoryID=sc.CategoryID WHERE sc.SubCategoryID='" + dtTemp.Rows[0]["SubCategoryID"].ToString() + "'");
                dr["SubCategory"] = StockReports.ExecuteScalar("SELECT sc.Name FROM f_subcategorymaster sc WHERE sc.SubCategoryID='" + dtTemp.Rows[0]["SubCategoryID"].ToString() + "'");
                dr["ItemID"] = ItemID;
                dr["Item"] = dtTemp.Rows[0]["Item"].ToString();
                dr["Quantity"] = IssueQty;
                dr["Rate"] = dtTemp.Rows[0]["Rate"].ToString();
                dr["Date"] = System.DateTime.Now;
                dr["SubCategoryID"] = dtTemp.Rows[0]["SubCategoryID"].ToString();
                dr["DoctorID"] = dtServiceDetail.Rows[0]["DoctorID"].ToString();
                dr["Name"] = StockReports.GetDoctorNameByDoctorID(dtServiceDetail.Rows[0]["DoctorID"].ToString());
                dr["DocCharges"] = "0.00";
                dr["TnxTypeID"] = "7";
                dr["ItemDisplayName"] = dtTemp.Rows[0]["Item"].ToString();
                dr["ItemCode"] = dtTemp.Rows[0]["ItemCode"].ToString();
                dr["ConfigID"] = dtTemp.Rows[0]["ConfigID"].ToString();
                dr["RateListID"] = dtTemp.Rows[0]["ID"].ToString();

                dtItem.Rows.Add(dr);
                ViewState.Add("dtItem", dtItem);

                dtItem.AcceptChanges();
            }
            else
            {
                lblMsg.Text = "Rate are not Fixed of Cross Match charge, contact to IT Department";
                return;
            }
            string IsVerified = "1";
            string LdgTnxDtlID=string.Empty;
            if (isEmergencyPatient)
            {

				
				  var isBillGenereted = AllLoadData_IPD.CheckBillGenerate(TID, "EMG");

                if (isBillGenereted > 0) {
                    lblMsg.Text = "Bill Already Generated.";
                    return;
                }
				
				
				
				

				
                 ledgerTransactionNo = StockReports.ExecuteScalar("SELECT emd.LedgerTransactionNo FROM emergency_patient_details emd WHERE emd.TransactionId='" + TID + "'");


                for (int i = 0; i < dtItem.Rows.Count; i++)
                {

                    if (IssueQty > 0 && isBilling==1)
                    {
                        LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(Tranx);
                        ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                        ObjLdgTnxDtl.LedgerTransactionNo = ledgerTransactionNo;
                        ObjLdgTnxDtl.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]).Trim();
                        ObjLdgTnxDtl.Rate = Util.GetDecimal(dtItem.Rows[i]["Rate"]);
                        ObjLdgTnxDtl.Quantity = Util.GetDecimal(IssueQty);
                        ObjLdgTnxDtl.StockID = "";
                        ObjLdgTnxDtl.IsTaxable = "NO";

                        ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(0);
                        ObjLdgTnxDtl.DiscountPercentage = 0;
                        ObjLdgTnxDtl.Amount = Util.GetDecimal(ObjLdgTnxDtl.Rate * IssueQty);
                        if (ObjLdgTnxDtl.DiscountPercentage > 0)
                            ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.IsPackage = 0;
                        ObjLdgTnxDtl.PackageID = "";
                        ObjLdgTnxDtl.IsVerified = 1;
                        ObjLdgTnxDtl.TransactionID = lblTransaction_ID.Text;
                        ObjLdgTnxDtl.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]).Trim();
                        ObjLdgTnxDtl.ItemName = Util.GetString(dtItem.Rows[i]["Item"]).Trim();
                        ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        ObjLdgTnxDtl.DoctorID = Util.GetString(dtItem.Rows[i]["DoctorID"]);
                        ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItem.Rows[i]["SubCategoryID"]), con));
                        ObjLdgTnxDtl.TnxTypeID = Util.GetInt(dtItem.Rows[i]["TnxTypeID"]);
                        ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                        ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(0);
                        ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                        ObjLdgTnxDtl.RateListID = Util.GetInt(dtItem.Rows[i]["RateListID"]);
                        ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        ObjLdgTnxDtl.Type = "O";
                        ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                        ObjLdgTnxDtl.rateItemCode = Util.GetString(dtItem.Rows[i]["ItemCode"]);
                        ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.roundOff = 0;
                        ObjLdgTnxDtl.typeOfTnx = "OPD-BILLING";
                        ObjLdgTnxDtl.IPDCaseTypeID = IPDCaseType_ID;

                        LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                    }

                }

            }
            else
            {
				
				var isBillGenereted = AllLoadData_IPD.CheckBillGenerate(lblTransaction_ID.Text.Trim(), "IPD");

                if (isBillGenereted > 0)
                {
                    lblMsg.Text = "Bill Already Generated.";
                    return;
                }
				
				
                if (IssueQty > 0 && isBilling==1)
                    dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, lblPatientId.Text.Trim(), "IPD-Billing", Util.GetInt(PanelID), ViewState["ID"].ToString(), lblTransaction_ID.Text.Trim(), Util.GetString(Session["HOSPID"].ToString()), "Yes", IsVerified, Tranx, IPDCaseType_ID, PatientType, con, "");
            }


            string StockIDs = string.Empty;
            if (dtItem.Columns.Contains("LedgerTransactionNo") == false)
            {
                dtItem.Columns.Add("LedgerTransactionNo");
                dtItem.Rows[0]["LedgerTransactionNo"] = "";
            }

            if (isEmergencyPatient)
                dtItem.Rows[0]["LedgerTransactionNo"] = ledgerTransactionNo;


            foreach (GridViewRow gr in grdRequestList.Rows)
            {
                if (((CheckBox)gr.FindControl("chkYes")).Checked)
                {
                    // Insert into CrossMatch Table
                    string str = "INSERT INTO bb_blood_crossmatch (ItemID,ComponentID,ComponentName,ServiceRequestID,TransactionID,PatientID,BloodStockID,BBTubeNo,Entryby,LedgerTnxNo,Compatiblity) ";
                    str += "VALUES('" + lblItemID.Text + "','" + Util.GetInt(((Label)gr.FindControl("lblcomponentid")).Text) + "','" + ((Label)gr.FindControl("lblComponentName")).Text + "','" + lblServiceID.Text + "', ";
                    str += " '" + lblTransaction_ID.Text + "','" + lblPatientId.Text + "','" + ((Label)gr.FindControl("lblStockId1")).Text + "','" + ((Label)gr.FindControl("lblBBTubeNo")).Text + "','" + Session["ID"].ToString() + "', ";
                    str += " " + Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()) + ", '" + Util.GetString(((DropDownList)gr.FindControl("ddlCompatibility")).SelectedValue) + "')";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                    ((CheckBox)gr.FindControl("chkYes")).Enabled = false;
                    if (Util.GetString(((DropDownList)gr.FindControl("ddlCompatibility")).SelectedValue) != "UnCompatible")
                    {
                        // Insert into IssueBlood with hold
                        decimal vol = Util.GetDecimal(((Label)gr.FindControl("lblInitialCount")).Text);
                        int count = Util.GetInt(((Label)gr.FindControl("lblID1")).Text);

                        IssueBlood ib = new IssueBlood(Tranx);
                        ib.IssueVolumn = vol;
                        ib.componentid = Util.GetInt(((Label)gr.FindControl("lblcomponentid")).Text);
                        ib.IssueBy = Session["ID"].ToString();
                        ib.CentreId = Util.GetInt(Session["CentreID"].ToString());
                        ib.PatientID = lblPatientId.Text;

                        ib.TransactionID = lblTransaction_ID.Text;
                        ib.Stock_ID = ((Label)gr.FindControl("lblStockId1")).Text;
                        ib.ComponentName = ((Label)gr.FindControl("lblComponentName")).Text;
                        ib.BBTubeNo = ((Label)gr.FindControl("lblBBTubeNo")).Text;
                        ib.BagType = ((Label)gr.FindControl("lblbagtype")).Text;
                        ib.Expiry = Util.GetDateTime(((Label)gr.FindControl("lblExpiry")).Text);
                        ib.vTYPE = Util.GetString(lblTypeOfTnx.Text.ToString().ToUpper());
                        ib.IsReturn = 0;
                        ib.ItemID = Util.GetString(lblItemID.Text.ToString());

                        ib.IsHold = 1;
                        ib.HoldDate = Util.GetDateTime(System.DateTime.Now);
                        ib.HoldBy = ViewState["ID"].ToString();
                        ib.ServiceRequestID = Util.GetInt(lblServiceID.Text.Trim());
                        //  ib.ReasonOf = txtReason.Text;

                        IssueId = ib.Insert();

                        string up8 = "UPDATE bb_stock_master SET IsHold=1 ,HoldBy='" + Session["ID"].ToString() + "',HoldDate=now() where ID=" + count + " ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up8);

                        if (StockIDs != string.Empty)
                            StockIDs += ",'" + ((Label)gr.FindControl("lblStockId1")).Text + "'";
                        else
                            StockIDs = "'" + ((Label)gr.FindControl("lblStockId1")).Text + "'";
                    }

                }
                else
                {
                    gr.Visible = false;
                }
            }

            //Devendra Singh 2018-10-10 Insert Finance Integarion 
            if (isEmergencyPatient)
            {
                if (Resources.Resource.AllowFiananceIntegration == "1" && dtItem.Rows[0]["LedgerTransactionNo"].ToString() != "")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()), "", "E", LdgTnxDtlID, Tranx));
                    if (IsIntegrated == "0")
                    {
                        Tranx.Rollback();
                        return;
                    }
                }
            }
            else
            {
                if (Resources.Resource.AllowFiananceIntegration == "1" && dtItem.Rows[0]["LedgerTransactionNo"].ToString() != "")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()), "", "R", Tranx));
                    if (IsIntegrated == "0")
                    {
                        Tranx.Rollback();
                        return;
                    }
                }
            }



            Tranx.Commit();



            lblMsg.Text = "Blood Has been Reserved";
            if (StockIDs != string.Empty)
                PrintCrossMatchRecord(TID, StockIDs, lblTypeOfTnx.Text);
            search("");
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();

            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void PrintCrossMatchRecord(string TransactionID, string StockIDs, string tnxType,int multiple=1)
    {
        StringBuilder sb = new StringBuilder();
        if (multiple == 0)
            StockIDs = "'" + StockIDs + "'";
      
        if (tnxType == "IPD")
        {
            sb.Append(" SELECT pm.PatientID,pm.PFirstName,pm.PLastName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,pm.Gender,cm.ComponentName,cm.CrossmatchValidity,pm.BloodGroup as PatientBG, bbc.BBTubeNo AS bagNo,DATE_FORMAT(bbc.EntryDate,'%d-%b-%Y')EntryDate,CONCAT(em.Title,'',em.Name)Entryby, ");
            sb.Append(" (SELECT CONCAT(icm.Name,'/',rm.Name,'/',rm.Bed_No)AS ward FROM patient_ipd_profile pip INNER JOIN ipd_case_type_master icm ON pip.IPDCaseTypeID=icm.IPDCaseTypeID INNER JOIN room_master rm ON pip.RoomID=rm.RoomId WHERE pip.TransactionID= bbc.transactionid ORDER BY pip.PatientIPDProfile_ID DESC LIMIT 1)ward, ");
            sb.Append(" sm.BloodGroup AS CrossMatchBG FROM bb_blood_crossmatch bbc  ");
            sb.Append(" INNER JOIN patient_master pm ON bbc.PatientID=pm.PatientID INNER JOIN bb_component_master cm ON cm.Id=bbc.ComponentID ");
            sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=bbc.Entryby INNER JOIN bb_stock_master sm ON sm.Stock_Id=bbc.BloodStockID ");
            sb.Append(" WHERE bbc.TransactionID='" + TransactionID + "' and bbc.BloodStockID in (" + StockIDs + ") group by bbc.BloodStockID");
        }
        else if (tnxType == "EMG")
        {
            sb.Append(" SELECT pm.PatientID,pm.PFirstName,pm.PLastName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,pm.Gender,cm.ComponentName,cm.CrossmatchValidity,pm.BloodGroup as PatientBG, bbc.BBTubeNo AS bagNo,DATE_FORMAT(bbc.EntryDate,'%d-%b-%Y')EntryDate,CONCAT(em.Title,'',em.Name)Entryby, ");
            sb.Append(" CONCAT(icm.Name,'/',rm.Name,'/',rm.Bed_No)AS ward,sm.BloodGroup AS CrossMatchBG FROM bb_blood_crossmatch bbc  INNER JOIN emergency_patient_details emr ON emr.TransactionId=bbc.TransactionID  ");
            sb.Append(" INNER JOIN patient_master pm ON emr.PatientID=pm.PatientID INNER JOIN bb_component_master cm ON cm.Id=bbc.ComponentID INNER JOIN ipd_case_type_master icm ON emr.IPDCaseTypeID=icm.IPDCaseTypeID ");
            sb.Append(" INNER JOIN room_master rm ON emr.RoomID=rm.RoomId INNER JOIN employee_master em ON em.Employee_ID=bbc.Entryby INNER JOIN bb_stock_master sm ON sm.Stock_Id=bbc.BloodStockID ");
            sb.Append(" WHERE bbc.TransactionID='" + TransactionID + "' and bbc.BloodStockID in (" + StockIDs + ") group by bbc.BloodStockID");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            DataTable dtImg = new DataTable();
            dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "CrossMatchDonePrintOut";
            //ds.WriteXmlSchema("D:/CrossMatchDonePrintOut.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }
    protected void btnShowStock_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IssueQty = 0;
            string IssueId = string.Empty;
            foreach (GridViewRow gr in grdRequestList.Rows)
            {
                if (((CheckBox)gr.FindControl("chkYes")).Checked)
                {
                    IssueQty = IssueQty + 1;
                }
            }
            decimal record = Util.GetDecimal(lblQtypending.Text);
            if (IssueQty > record)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM206','" + lblMsg.ClientID + "');", true);

                return;
            }

            if (rdbType.SelectedValue == "OPD" || rdbType.SelectedValue == "EMG" || rdbType.SelectedValue == "IPD" || rdbType.SelectedValue == "All")
            {
                foreach (GridViewRow gr in grdRequestList.Rows)
                {
                    if (((CheckBox)gr.FindControl("chkYes")).Checked)
                    {
                        decimal vol = Util.GetDecimal(((Label)gr.FindControl("lblInitialCount")).Text);
                        int count = Util.GetInt(((Label)gr.FindControl("lblID1")).Text);
                        IssueBlood ib = new IssueBlood(Tranx);
                        ib.IssueVolumn = vol;
                        ib.componentid = Util.GetInt(((Label)gr.FindControl("lblcomponentid")).Text);
                        ib.IssueBy = Session["ID"].ToString();
                        ib.CentreId = Util.GetInt(Session["CentreID"].ToString());
                        ib.PatientID = lblPatientId.Text;
                        ib.LedgerTransactionNo = Util.GetInt(lblLedgerTransactionNo.Text);
                        ib.TransactionID = lblTransaction_ID.Text;
                        ib.Stock_ID = ((Label)gr.FindControl("lblStockId1")).Text;
                        ib.ComponentName = ((Label)gr.FindControl("lblComponentName")).Text;
                        ib.BBTubeNo = ((Label)gr.FindControl("lblBBTubeNo")).Text;
                        ib.BagType = ((Label)gr.FindControl("lblbagtype")).Text;
                        ib.Expiry = Util.GetDateTime(((Label)gr.FindControl("lblExpiry")).Text);
                        ib.vTYPE = Util.GetString(lblTypeOfTnx.Text.ToString().ToUpper());
                        ib.IsReturn = 0;
                        ib.ItemID = Util.GetString(lblItemID.Text.ToString());
                        ib.LedgerTnxID = lblLedgerTnxID.Text.ToString();
                        ib.ServiceRequestID = Util.GetInt(((Label)gr.FindControl("lblServiceRequestID")).Text);
                        //  ib.ReasonOf = txtReason.Text;

                        IssueId = ib.Insert();

                        string up8 = "UPDATE bb_stock_master SET ReleaseCount=ReleaseCount+" + vol + ",IssuedBy='" + Session["ID"].ToString() + "',status=1,IssueDate=now(),ReasonOf='" + txtReason.Text + "' where ID=" + count + " ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up8);
                        string up2 = "UPDATE f_ledgertnxdetail SET BloodIssue=BloodIssue+" + 1 + " where LedgerTnxID='" + lblLedgerTnxID.Text + "' ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);
                        string up3 = "UPDATE f_ledgertnxdetail SET BloodIssue=1 WHERE ItemID='" + lblItemID.Text + "' AND LedgerTransactionNo='" + lblLedgerTnxID.Text + "'";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up3);
                    }
                }
            }
            //else if (rdbType.SelectedValue == "IPD")
            //{



            //    DataTable dtServiceDetail = StockReports.GetDataTable("Select * from ipdservices_request where id='" + lblServiceID.Text + "'");

            //    // Insert a Single Item Cross Match 
            //    string PanelID = lblPanelID.Text.Trim();
            //    string IPDCaseType_ID = lblIPDCaseType_Id.Text;
            //    string TID = lblTransactionID.Text;
            //    string PID = lblPatientId.Text.Trim();
            //    string Ref_Code = StockReports.ExecuteScalar(" SELECT ReferenceCode FROM f_panel_master WHERE PanelID='" + lblPanelID.Text + "' AND isactive=1 ");
            //    string ItemID = lblItemID.Text.Trim();// Component ItemID
            //    string ScheduleCHargeID = StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE panelId='" + Ref_Code + "' AND isdefault=1 ");
            //    string PatientType = StockReports.ExecuteScalar("Select PMH.Patient_Type from patient_medical_history pmh where pmh.TransactionID='" + lblTransactionID.Text.Trim() + "'");
            //    DataTable dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + ItemID + "'", Ref_Code, IPDCaseType_ID, ScheduleCHargeID, ViewState["CentreID"].ToString());
            //    CreateTable();
            //    if (dtTemp != null && dtTemp.Rows.Count > 0)
            //    {

            //        DataRow dr = dtItem.NewRow();
            //        dr["Category"] = StockReports.ExecuteScalar("SELECT cm.Name FROM f_categorymaster cm INNER JOIN f_subcategorymaster sc ON cm.CategoryID=sc.CategoryID WHERE sc.SubCategoryID='" + dtTemp.Rows[0]["SubCategoryID"].ToString() + "'");
            //        dr["SubCategory"] = StockReports.ExecuteScalar("SELECT sc.Name FROM f_subcategorymaster sc WHERE sc.SubCategoryID='" + dtTemp.Rows[0]["SubCategoryID"].ToString() + "'");
            //        dr["ItemID"] = ItemID;
            //        dr["Item"] = dtTemp.Rows[0]["Item"].ToString();
            //        dr["Quantity"] = IssueQty;
            //        dr["Rate"] = dtTemp.Rows[0]["Rate"].ToString();
            //        dr["Date"] = System.DateTime.Now;
            //        dr["SubCategoryID"] = dtTemp.Rows[0]["SubCategoryID"].ToString();
            //        dr["DoctorID"] = dtServiceDetail.Rows[0]["DoctorID"].ToString();
            //        dr["Name"] = StockReports.GetDoctorNameByDoctorID(dtServiceDetail.Rows[0]["DoctorID"].ToString());
            //        dr["DocCharges"] = "0.00";
            //        dr["TnxTypeID"] = "7";
            //        dr["ItemDisplayName"] = dtTemp.Rows[0]["Item"].ToString();
            //        dr["ItemCode"] = dtTemp.Rows[0]["ItemCode"].ToString();
            //        dr["ConfigID"] = dtTemp.Rows[0]["ConfigID"].ToString();
            //        dr["RateListID"] = dtTemp.Rows[0]["ID"].ToString();

            //        dtItem.Rows.Add(dr);
            //        ViewState.Add("dtItem", dtItem);

            //        dtItem.AcceptChanges();
            //    }
            //    else
            //    {
            //        lblMsg.Text = "Rate are not Fixed of Cross Match charge, contact to IT Department";
            //    }

            //    string IsVerified = "1";
            //    dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, lblPatientId.Text.Trim(), "IPD-Billing", Util.GetInt(PanelID), ViewState["ID"].ToString(), lblTransactionID.Text.Trim(), Util.GetString(Session["HOSPID"].ToString()), "Yes", IsVerified, Tranx, IPDCaseType_ID, PatientType, con, "");


            //    foreach (GridViewRow gr in grdRequestList.Rows)
            //    {
            //        if (((CheckBox)gr.FindControl("chkYes")).Checked)
            //        {
            //            decimal vol = Util.GetDecimal(((Label)gr.FindControl("lblInitialCount")).Text);
            //            int count = Util.GetInt(((Label)gr.FindControl("lblID1")).Text);

            //            string strLt = "SELECT LedgertnxID FROM f_ledgertnxdetail WHERE LedgerTransactionNo=" + Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()) + " AND itemid='" + ItemID + "'";
            //            string LedgerTnxID = Util.GetString(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, strLt));

            //            string up1 = "UPDATE bb_issue_blood SET IsHold=0 ,IssueBy='" + Session["ID"].ToString() + "', HoldIssueBy='" + Session["ID"].ToString() + "',HoldIssueDate=NOW(),LedgerTransactionNo=" + Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()) + " where ServiceRequestID=" + Util.GetInt(lblServiceID.Text.Trim()) + " ";
            //            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);

            //            string up8 = "UPDATE bb_stock_master SET ReleaseCount=ReleaseCount+1, IssuedBy='" + Session["ID"].ToString() + "',status=1,IssueDate=now(),IsHold=0 where ID=" + count + " ";
            //            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up8);

            //            string up2 = "UPDATE f_ledgertnxdetail SET BloodIssue=BloodIssue+" + 1 + " where LedgerTnxID='" + LedgerTnxID + "' ";
            //            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);

            //            string up3 = "UPDATE ipdservices_request SET IsBilled=1, BilledBy='" + Session["ID"].ToString() + "',  BilledDateTime=Now() , LedgerTnxNo=" + Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()) + " WHERE id=" + Util.GetInt(lblServiceID.Text.Trim()) + " ";
            //            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up3);
            //        }
            //    }
            //}

            //Devendra Singh 2018-10-10 Insert Finance Integarion 
            //if (Resources.Resource.AllowFiananceIntegration == "1")
            //{
            //    string IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(Util.GetInt(LedgerTransactionNo), ReceiptNo, "R", tnx));
            //    if (IsIntegrated == "0")
            //    {
            //        tnx.Rollback();
            //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
            //    }
            //}

            Tranx.Commit();

            pnlSearch.Visible = false;
            pnlRequest.Visible = false;
            grdRequestList.DataSource = null;
            grdRequestList.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            btnCrossMatch.Enabled = true;
            search("");
            string pageurl = "BloodIssue.aspx?issueStockID=" + IssueId + "";
            string Bloodurl = "BloodTransfusionFom.aspx?issueStockID=" + IssueId + "";
            Response.Write("<script>window.open('" + pageurl + "','_blank') </script>");
            Response.Write("<script>window.open('" + Bloodurl + "','_blank')</script>");

        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();

            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void CreateTable()
    {
        if (dtItem == null)
        {
            dtItem = new DataTable();
            dtItem.Columns.Add("Category");
            dtItem.Columns.Add("SubCategory");
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("Item");
            dtItem.Columns.Add("Quantity");
            dtItem.Columns.Add("Rate");
            dtItem.Columns.Add("SubCategoryID");
            dtItem.Columns.Add("Date");
            dtItem.Columns.Add("ItemDisplayName");
            dtItem.Columns.Add("ItemCode");
            dtItem.Columns.Add("DoctorID");
            dtItem.Columns.Add("Name");
            dtItem.Columns.Add("DocCharges");
            dtItem.Columns.Add("TnxTypeID");
            dtItem.Columns.Add("ConfigID");
            dtItem.Columns.Add(new DataColumn("RateListID"));
        }
    }

    protected void grdRequestList_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsCompatiblity")).Text == "UnCompatible")
            {
                ((DropDownList)e.Row.FindControl("ddlCompatibility")).SelectedIndex = ((DropDownList)e.Row.FindControl("ddlCompatibility")).Items.IndexOf(((DropDownList)e.Row.FindControl("ddlCompatibility")).Items.FindByValue(((Label)e.Row.FindControl("lblIsCompatiblity")).Text));
                ((CheckBox)e.Row.FindControl("chkYes")).Enabled = false;
                ((DropDownList)e.Row.FindControl("ddlCompatibility")).Enabled = false;
            }
            //if (((Label)e.Row.FindControl("lblIsCrossMatch")).Text.Trim() == "1" && ((Label)e.Row.FindControl("lblIsUnReserved")).Text.Trim() == "0")
            //{
            //    ((CheckBox)e.Row.FindControl("chkYes")).Checked = true;
            //    ((CheckBox)e.Row.FindControl("chkYes")).Enabled = false;
            //}
        }
    }
    protected void grdSearchList_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Util.GetString(((Label)e.Row.FindControl("lblTnxType1")).Text.Trim()) != "IPD")
                ((Label)e.Row.FindControl("lblTransactionID3")).Visible = false;
            decimal CrossMatchQty = Util.GetDecimal(((Label)e.Row.FindControl("lblIsCrossMatch")).Text.Trim());
            decimal PendingQty = Util.GetDecimal(((Label)e.Row.FindControl("lblPendQuantity")).Text.Trim());
            decimal ReqQuantity = Util.GetDecimal(((Label)e.Row.FindControl("lblQuantity")).Text.Trim());
            decimal IssueQuantity = Util.GetDecimal(((Label)e.Row.FindControl("lblIssueQuantity")).Text.Trim());
            string Compatible = Util.GetString(((Label)e.Row.FindControl("lblCompatiblity")).Text);
            decimal RejQty = Util.GetDecimal(((Label)e.Row.FindControl("lblRejectQuantity")).Text.Trim());
            //decimal crossmatchquantity = Util.GetDecimal(StockReports.ExecuteScalar("SELECT COUNT(ServiceRequestID) FROM bb_blood_CrossMatch cm WHERE cm.ServiceRequestID='" + ((Label)e.Row.FindControl("lblServiceID")).Text.Trim() + "';"));
            if (rdbType.SelectedValue == "All" || rdbType.SelectedValue != "OPD")
            {
                if (CrossMatchQty == ReqQuantity)
                {
                    ((ImageButton)e.Row.FindControl("imgIssue")).Visible = true;
                    e.Row.Attributes["style"] = "background-color: #f38f78";
                    ((ImageButton)e.Row.FindControl("imgReject")).Visible = false;
                    ((ImageButton)e.Row.FindControl("imgResult")).Visible = false;
                }
                if (CrossMatchQty < ReqQuantity && CrossMatchQty != Util.GetDecimal(0))
                {

                    ((ImageButton)e.Row.FindControl("imgIssue")).Visible = true;
                    e.Row.Attributes["style"] = "background-color: #f38f78";
                    ((ImageButton)e.Row.FindControl("imgReject")).Visible = true;
                }
                if (CrossMatchQty == Util.GetDecimal(0))
                {
                    ((ImageButton)e.Row.FindControl("imgIssue")).Visible = false;
                    ((ImageButton)e.Row.FindControl("imgReject")).Visible = true;
                    ((ImageButton)e.Row.FindControl("imgResult")).Visible = true;
                }
                if (ReqQuantity == RejQty)
                {
                    ((ImageButton)e.Row.FindControl("imgIssue")).Visible = false;
                    ((ImageButton)e.Row.FindControl("imgReject")).Visible = false;
                    ((ImageButton)e.Row.FindControl("imgResult")).Visible = false;
                }
                //else
                //{
                //    ((ImageButton)e.Row.FindControl("imgResult")).Visible = false;
                //}
                if (IssueQuantity == ReqQuantity)
                {
                    e.Row.Attributes["style"] = "background-color: #69e6b0";
                }

                if (Util.GetString(((Label)e.Row.FindControl("lblTnxType1")).Text.Trim()) == "OPD")
                    ((ImageButton)e.Row.FindControl("imgReject")).Visible = false;
            }
        }
    }
    protected void btnCIssue_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IssueQty = 0;
            string IssueId = string.Empty;
            foreach (GridViewRow gr in grdIssue.Rows)
            {
                if (((CheckBox)gr.FindControl("chkIssue")).Checked)
                {
                    IssueQty = IssueQty + 1;
                }
            }
            //decimal record = Util.GetDecimal(lblQtypending.Text);
            //if (IssueQty > record)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM206','" + lblMsg.ClientID + "');", true);

            //    return;
            //}
            if (IssueQty == 0)
            {
                lblMsg.Text = "Please check at least one stock";
                return;
            }
            DataTable dtServiceDetail = StockReports.GetDataTable("Select * from ipdservices_request where id='" + lblServiceID.Text + "'");

            // Insert Component Item
            string PanelID = lblPanelID.Text.Trim();
            string IPDCaseType_ID = lblIPDCaseType_Id.Text;
            string TID = lblTransaction_ID.Text;
            string PID = lblPatientId.Text.Trim();
            string Ref_Code = StockReports.ExecuteScalar(" SELECT ReferenceCode FROM f_panel_master WHERE PanelID='" + lblPanelID.Text + "' AND isactive=1 ");
            string ItemID = lblItemID.Text.Trim();// Component ItemID
            string ScheduleCHargeID = StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE panelId='" + Ref_Code + "' AND isdefault=1 ");
            string PatientType = StockReports.ExecuteScalar("Select PMH.Patient_Type from patient_medical_history pmh where pmh.TransactionID='" + lblTransaction_ID.Text.Trim() + "'");

            DataTable dtTemp = new DataTable();

            var isEmergencyPatient = dtServiceDetail.Rows[0]["Patient_Type"].ToString().ToUpper() == "EMG" ? true : false;
            if (isEmergencyPatient == false)
            {
                if (AllLoadData_IPD.CheckBillGenerate(TID, "IPD") > 0)
                {
                    lblMsg.Text = "Bill Already Generated";
                    return;
                }
            }
            else if (isEmergencyPatient == true)
            {
                if (AllLoadData_IPD.CheckBillGenerate(TID, "EMG") > 0)
                {
                    lblMsg.Text = "Bill Already Generated";
                    return;
                }
            }

            if (isEmergencyPatient)
                dtTemp = StockReports.GetDataTable("select im.SubCategoryID,im.TypeName item,con.ConfigID, (IFNULL(rt.Rate,0))Rate,rt.ScheduleChargeID,rt.ID,IFNULL(rt.ItemCode,'')ItemCode,IFNULL(rt.ItemDisplayName,'')ItemDisplayName  from f_ratelist rt INNER JOIN f_itemmaster im ON im.ItemID=rt.ItemID INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID INNER JOIN  f_categorymaster c ON  c.CategoryID=sm.CategoryID INNER JOIN f_configrelation con ON c.CategoryID=con.CategoryID  INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rt.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID where rt.ItemID='" + ItemID + "' and rt.PanelID=" + Ref_Code + " and IsCurrent=1 and rt.CentreID='" + Session["CentreID"].ToString() + "'");
            else
                dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + ItemID + "'", Ref_Code, IPDCaseType_ID, ScheduleCHargeID, ViewState["CentreID"].ToString());

            CreateTable();
            if (dtTemp != null && dtTemp.Rows.Count > 0)
            {

                DataRow dr = dtItem.NewRow();
                dr["Category"] = StockReports.ExecuteScalar("SELECT cm.Name FROM f_categorymaster cm INNER JOIN f_subcategorymaster sc ON cm.CategoryID=sc.CategoryID WHERE sc.SubCategoryID='" + dtTemp.Rows[0]["SubCategoryID"].ToString() + "'");
                dr["SubCategory"] = StockReports.ExecuteScalar("SELECT sc.Name FROM f_subcategorymaster sc WHERE sc.SubCategoryID='" + dtTemp.Rows[0]["SubCategoryID"].ToString() + "'");
                dr["ItemID"] = ItemID;
                dr["Item"] = dtTemp.Rows[0]["Item"].ToString();
                dr["Quantity"] = IssueQty;
                dr["Rate"] = dtTemp.Rows[0]["Rate"].ToString();
                dr["Date"] = System.DateTime.Now;
                dr["SubCategoryID"] = dtTemp.Rows[0]["SubCategoryID"].ToString();
                dr["DoctorID"] = dtServiceDetail.Rows[0]["DoctorID"].ToString();
                dr["Name"] = StockReports.GetDoctorNameByDoctorID(dtServiceDetail.Rows[0]["DoctorID"].ToString());
                dr["DocCharges"] = "0.00";
                dr["TnxTypeID"] = "7";
                dr["ItemDisplayName"] = dtTemp.Rows[0]["Item"].ToString();
                dr["ItemCode"] = dtTemp.Rows[0]["ItemCode"].ToString();
                dr["ConfigID"] = dtTemp.Rows[0]["ConfigID"].ToString();
                dr["RateListID"] = dtTemp.Rows[0]["ID"].ToString();

                dtItem.Rows.Add(dr);
                ViewState.Add("dtItem", dtItem);

                dtItem.AcceptChanges();
            }
            else
            {
                lblMsg.Text = "Rate are not Fixed of Component, contact to IT Department";
                return;
            }

            string IsVerified = "1";

            string LdgTnxDtlID = string.Empty;
            if (isEmergencyPatient)
            {

                var ledgerTransactionNo = StockReports.ExecuteScalar("SELECT emd.LedgerTransactionNo FROM emergency_patient_details emd WHERE emd.TransactionId='" + TID + "'");


                for (int i = 0; i < dtItem.Rows.Count; i++)
                {

                    if (IssueQty > 0)
                    {
                        LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(Tranx);
                        ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                        ObjLdgTnxDtl.LedgerTransactionNo = ledgerTransactionNo;
                        ObjLdgTnxDtl.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]).Trim();
                        ObjLdgTnxDtl.Rate = Util.GetDecimal(dtItem.Rows[i]["Rate"]);
                        ObjLdgTnxDtl.Quantity = Util.GetDecimal(IssueQty);
                        ObjLdgTnxDtl.StockID = "";
                        ObjLdgTnxDtl.IsTaxable = "NO";

                        ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(0);
                        ObjLdgTnxDtl.DiscountPercentage = 0;
                        ObjLdgTnxDtl.Amount = Util.GetDecimal(ObjLdgTnxDtl.Rate * IssueQty);
                        if (ObjLdgTnxDtl.DiscountPercentage > 0)
                            ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.IsPackage = 0;
                        ObjLdgTnxDtl.PackageID = "";
                        ObjLdgTnxDtl.IsVerified = 1;
                        ObjLdgTnxDtl.TransactionID = lblTransaction_ID.Text;
                        ObjLdgTnxDtl.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]).Trim();
                        ObjLdgTnxDtl.ItemName = Util.GetString(dtItem.Rows[i]["Item"]).Trim();
                        ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        ObjLdgTnxDtl.DoctorID = Util.GetString(dtItem.Rows[i]["DoctorID"]);
                        ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItem.Rows[i]["SubCategoryID"]), con));
                        ObjLdgTnxDtl.TnxTypeID = Util.GetInt(dtItem.Rows[i]["TnxTypeID"]);
                        ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                        ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(0);
                        ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                        ObjLdgTnxDtl.RateListID = Util.GetInt(dtItem.Rows[i]["RateListID"]);
                        ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        ObjLdgTnxDtl.Type = "O";
                        ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                        ObjLdgTnxDtl.rateItemCode = Util.GetString(dtItem.Rows[i]["ItemCode"]);
                        ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                        ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                        ObjLdgTnxDtl.roundOff = 0;
                        ObjLdgTnxDtl.typeOfTnx = "OPD-BILLING";
                        ObjLdgTnxDtl.IPDCaseTypeID = IPDCaseType_ID;

                        LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                        if (isEmergencyPatient)
                        {
                            if (Resources.Resource.AllowFiananceIntegration == "1" && dtItem.Rows[0]["LedgerTransactionNo"].ToString() != "")
                            {
                                string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()), "", "R", LdgTnxDtlID, Tranx));
                                if (IsIntegrated == "0")
                                {
                                    Tranx.Rollback();
                                    return;
                                }
                                IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LdgTnxDtlID), 0, 26, 0, Tranx));
                                if (IsIntegrated == "0")
                                {
                                    Tranx.Rollback();
                                    return;
                                }
                            }

                        }

                        if (dtItem.Columns.Contains("LedgerTransactionNo") == false)
                        {
                            dtItem.Columns.Add("LedgerTransactionNo");
                            dtItem.Rows[0]["LedgerTransactionNo"] = ledgerTransactionNo;
                        }
                    }

                }

            }
            else
            {
                dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, lblPatientId.Text.Trim(), "IPD-Billing", Util.GetInt(PanelID), ViewState["ID"].ToString(), lblTransaction_ID.Text.Trim(), Util.GetString(Session["HOSPID"].ToString()), "Yes", IsVerified, Tranx, IPDCaseType_ID, PatientType, con, "");
            }

            foreach (GridViewRow gr in grdIssue.Rows)
            {
                if (((CheckBox)gr.FindControl("chkIssue")).Checked)
                {
                    string StockID = Util.GetString(((Label)gr.FindControl("lblCStockID")).Text);

                    string strLt = "SELECT LedgertnxID FROM f_ledgertnxdetail WHERE LedgerTransactionNo=" + Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()) + " AND itemid='" + ItemID + "'";
                    string LedgerTnxID = Util.GetString(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, strLt));

                    string strIssueId = "SELECT Issue_ID FROM bb_issue_blood WHERE TransactionID='" + TID + "' AND ServiceRequestID=" + Util.GetInt(lblServiceID.Text.Trim()) + " AND stock_id='" + StockID + "' AND isactive=1 ORDER BY id DESC";
                    string Issue_Id = Util.GetString(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, strIssueId));

                    string up1 = "UPDATE bb_issue_blood SET IsHold=0 ,IssueBy='" + Session["ID"].ToString() + "', HoldIssueBy='" + Session["ID"].ToString() + "',HoldIssueDate=NOW(),LedgerTransactionNo=" + Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()) + ",LedgerTnxID='" + LedgerTnxID + "' where ServiceRequestID=" + Util.GetInt(lblServiceID.Text.Trim()) + " and Issue_id='" + Issue_Id + "'";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);

                    string up8 = "UPDATE bb_stock_master SET ReleaseCount=ReleaseCount+1,IssuedBy='" + Session["ID"].ToString() + "',status=1,IssueDate=now(),IsHold=0 where Stock_Id='" + StockID + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up8);

                    string up2 = "UPDATE f_ledgertnxdetail SET BloodIssue=BloodIssue+" + 1 + " where LedgerTnxID='" + LedgerTnxID + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);

                    string up3 = "UPDATE ipdservices_request SET IsBilled=1, BilledBy='" + Session["ID"].ToString() + "',  BilledDateTime=Now() , LedgerTnxNo=" + Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()) + " WHERE id=" + Util.GetInt(lblServiceID.Text.Trim()) + " ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up3);
                }
            }
          
            if (!isEmergencyPatient)
            {
                if (Resources.Resource.AllowFiananceIntegration == "1" && dtItem.Rows[0]["LedgerTransactionNo"].ToString() != "")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()), "", "R", Tranx));
                    if (IsIntegrated == "0")
                    {
                        Tranx.Rollback();
                        return;
                    }
                    IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(dtItem.Rows[0]["LedgerTransactionNo"].ToString()),0, 22,0, Tranx));
                    if (IsIntegrated == "0")
                    {
                        Tranx.Rollback();
                        return;
                    }
                }
            }
            Tranx.Commit();

            pnlSearch.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            search("");
            //     string pageurl = "BloodIssue.aspx?issueStockID=" + IssueId + "";
            //    string Bloodurl = "BloodTransfusionFom.aspx?issueStockID=" + IssueId + "";
            //    Response.Write("<script>window.open('" + pageurl + "','_blank') </script>");
            //     Response.Write("<script>window.open('" + Bloodurl + "','_blank')</script>");
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();

            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnUpdateBloodgroup_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction();

        string BloodGroup = "";
        if (ddlBloodGroup.SelectedItem.Text != "NA")
            BloodGroup = ddlBloodGroup.SelectedItem.Text;

        string str = "Update Patient_master set bloodgroup='" + BloodGroup + "' where PatientID='" + lblPatientId.Text + "'";
        MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, str);
        objtnx.Commit();

        lblMsg.Text = "Blood Group Updated";
        lblBloodGroup.Text = BloodGroup;
        objtnx.Dispose();
        con.Close();
        con.Dispose();
    }

    protected void btnUnReserve_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow gr in grdIssue.Rows)
            {
                if (((CheckBox)gr.FindControl("chkIssue")).Checked)
                {
                    string st1 = "UPDATE bb_stock_master SET IsHold=0 ,HoldBy='" + Session["ID"].ToString() + "',HoldDate=now() where stock_ID='" + ((Label)gr.FindControl("lblCStockID")).Text + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, st1);

                    string st2 = "UPDATE bb_blood_crossmatch SET IsUnReserved=1,UnReservedBy='" + Session["ID"].ToString() + "',UnReseveDate=NOW() WHERE BloodStockID='" + ((Label)gr.FindControl("lblCStockID")).Text + "' and ServiceRequestID='" + ((Label)gr.FindControl("lblCServiceReqID")).Text + "'";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, st2);

                    string up1 = "UPDATE bb_issue_blood SET isactive=0 where ServiceRequestID='" + ((Label)gr.FindControl("lblCServiceReqID")).Text + "' and componentid='" + ((Label)gr.FindControl("lblCComponentID")).Text + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);
                }
            }
            Tranx.Commit();
            lblMsg.Text = "Blood Has been UnReserved";
            search("");
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();

            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void grdIssue_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsIssue")).Text.Trim() == "1")
            {
                ((CheckBox)e.Row.FindControl("chkIssue")).Enabled = false;
                e.Row.Attributes["style"] = "background-color: #69e6b0";
            }
        }
    }
    protected void grdIssue_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imgPrint")
        {
            string index = Util.GetString((e.CommandArgument));
            PrintCrossMatchRecord(index.Split('#')[2].ToString(), index.Split('#')[0].ToString(), index.Split('#')[1], 0);
            mpeIssue.Show();
        }
    }
}