using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;

public partial class Design_BloodBank_BloodReturn : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }

    protected void grdSearchList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (e.CommandName == "AResult")
            {
                int index = Util.GetInt(e.CommandArgument.ToString());
                GridViewRow gr = grdSearchList.Rows[index];

                string up1 = "UPDATE bb_issue_blood SET Isreturn=1 where issue_id='" + ((Label)gr.FindControl("lblissue_id")).Text.ToString() + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);

                string up2 = "UPDATE bb_stock_master SET ReleaseCount=ReleaseCount-'" + Util.GetInt(((Label)gr.FindControl("lblIssuevolumn")).Text.ToString()) + "' where Stock_Id='" + ((Label)gr.FindControl("lblStock_ID")).Text.ToString() + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);

                string str = "select * from f_ledgertnxdetail where LedgerTnxID='" + ((Label)gr.FindControl("ltdLedgerTnxID")).Text.ToString() + "' ";
                DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, str).Tables[0];

                LedgerTnxDetail tnxdtl = new LedgerTnxDetail(Tranx);

                tnxdtl.Location = Util.GetString(dt.Rows[0]["Location"]);
                tnxdtl.HospCode = Util.GetString(dt.Rows[0]["HospCode"]);
                tnxdtl.Hospital_Id = Util.GetString(dt.Rows[0]["Hospital_Id"]);
                tnxdtl.LedgerTransactionNo = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
                tnxdtl.Amount = Util.GetDecimal(dt.Rows[0]["Amount"]) * -1;
                tnxdtl.ItemID = Util.GetString(dt.Rows[0]["ItemID"]);
                tnxdtl.Rate = Util.GetDecimal(dt.Rows[0]["Rate"]) * -1;
                tnxdtl.Quantity = -1;
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
                tnxdtl.UserID = Util.GetString(Session["ID"]);
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
                tnxdtl.RoleID= Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                tnxdtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                int newLedgerTnxID = tnxdtl.Insert();

                BloodReturn Br = new BloodReturn(Tranx);
                Br.IssueId = ((Label)gr.FindControl("lblissue_id")).Text.ToString();
                Br.ComponentID = Util.GetInt(((Label)gr.FindControl("lblComponentId")).Text.ToString());
                Br.ComponentName = ((Label)gr.FindControl("lblComponent")).Text.ToString();
                Br.Stock_ID = ((Label)gr.FindControl("lblStock_ID")).Text.ToString();
                Br.PatientID = ((Label)gr.FindControl("lblPatientId")).Text.ToString();
                Br.TransactionID = ((Label)gr.FindControl("lblTransactionid")).Text.ToString();
                Br.CentreId = Util.GetInt(Session["Centre"].ToString());
                Br.ItemID = ((Label)gr.FindControl("lblitemid")).Text.ToString();
                Br.ReturnVolumn = Util.GetDecimal(((Label)gr.FindControl("lblIssuevolumn")).Text.ToString());
                Br.ReturnBy = Util.GetString(Session["ID"].ToString());
                Br.BBTubeNo = ((Label)gr.FindControl("lblBBTubeNo")).Text.ToString();
                string Bloodreturn = Br.Insert();
                if (newLedgerTnxID != 0 && Bloodreturn != "")
                {
                    Tranx.Commit();
                    grdSearchList.DataSource = null;
                    grdSearchList.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

                    search();
                }
            }
            if (e.CommandName == "AHold")
            {
                int index = Util.GetInt(e.CommandArgument.ToString());
                GridViewRow gr = grdSearchList.Rows[index];
                string up1 = "UPDATE bb_issue_blood SET IsHold=1 ,HoldBy='" + Session["ID"].ToString() + "',HoldDate=now() where issue_id='" + ((Label)gr.FindControl("lblissue_id")).Text.ToString() + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);

                string up2 = "UPDATE bb_stock_master SET IsHold=1 ,HoldBy='" + Session["ID"].ToString() + "',HoldDate=now() where Stock_Id='" + ((Label)gr.FindControl("lblStock_ID")).Text.ToString() + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);
                Tranx.Commit();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "clearAllField();", true);

                grdSearchList.DataSource = null;
                grdSearchList.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                Clear();
                search();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientName.Focus();
            txtfromdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
        }
        txtfromdate.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    private void Clear()
    {
        txtRegNo.Text = "";
        txtPatientName.Text = "";
        txtIPDNo.Text = "";
    }

    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.PName,issue_id,Issuevolumn,bbi.PatientID MRNo,REPLACE(TransactionID,'ISHHI','')IPDNo,TransactionID,LedgerTransactionNo,Stock_ID,bbi.BBTubeNo, ");
            sb.Append("   (SELECT ComponentName FROM bb_component_master WHERE ID=bbi.ComponentId AND  active=1)Component, ");
            sb.Append(" ComponentId,(SELECT TypeNAme FROM f_itemmaster WHERE itemid=bbi.itemid AND isactive=1)ItemName ");
            sb.Append(" ,itemid,bbi.LedgerTnxID,DATE_FORMAT(bbi.Expiry,'%d-%b-%Y')Expiry FROM  ");
            sb.Append(" bb_issue_blood bbi INNER JOIN patient_master pm ON pm.PatientID=bbi.PatientID   ");
            sb.Append(" WHERE bbi.isreturn=0 AND bbi.isactive=1   AND bbi.Expiry >=CURDATE() AND bbi.isHold=0 AND bbi.CentreID='" + Session["CentreID"].ToString() + "'");

            if (txtIPDNo.Text != "")
            {
                sb.Append(" AND TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
            }

            if (txtRegNo.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtRegNo.Text.Trim() + "' ");
            }

            if (txtPatientName.Text != "")
            {
                sb.Append(" AND pm.pname like '" + txtPatientName.Text.Trim() + "%' ");
            }
            if (rdbType.SelectedValue != "All")
            {
                sb.Append(" AND bbi.Type='" + rdbType.SelectedValue.ToString() + "'");
            }
            if (txtIPDNo.Text == "" && txtRegNo.Text == "" && txtPatientName.Text == "")
            {
                if (txtfromdate.Text != "")
                {
                    sb.Append(" AND DATE(IssuedDate) >='" + Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtdateTo.Text != "")
                {
                    sb.Append(" and DATE(IssuedDate) <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "' ");
                }
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdSearchList.DataSource = dt;
                grdSearchList.DataBind();
                grdSearchList.Enabled = true;
                pnlSearch.Visible = true;
                lblMsg.Text = "";
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

    
}