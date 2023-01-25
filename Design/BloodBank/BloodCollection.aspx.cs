using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_BloodCollection : System.Web.UI.Page
{

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        bool isTrue;
        if (ddlCompleted.SelectedItem.Text == "No")
        {
            isTrue = true;
        }
        else
        {
            isTrue = false;
            isTrue = validation();
        }
        if (isTrue)
        {
            lblMsg.Text = "";
            saveCollectionRecord();
        }
    }

    protected void grdDonor_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AResult")
        {
            string Query = " select bv.Visitor_ID,bv.Name,bv.Gender,bm.BloodGroup,bvh.Visit_ID,bvh.BagType,bvh.Quantity,DATE_FORMAT(bvh.dtEntry,'%d-%b-%y')dtEntry FROM bb_visitors bv INNER JOIN bb_visitors_History bvh on bv.Visitor_ID=bvh.Visitor_ID LEFT OUTER JOIN bb_bloodgroup_master bm ON bm.Id=bv.BloodGroup_Id where bv.Visitor_ID='" + e.CommandArgument.ToString().Split('#')[0] + "' and visit_id='" + e.CommandArgument.ToString().Split('#')[1] + "'AND bvh.isdonated=0";
            DataTable dt = StockReports.GetDataTable(Query);
            if (dt.Rows.Count > 0)
            {
                lblVisitID.Text = dt.Rows[0]["Visit_ID"].ToString();
                lblVisitorID1.Text = dt.Rows[0]["Visitor_ID"].ToString();
                lblName1.Text = dt.Rows[0]["Name"].ToString();
                lblGroup1.Text = dt.Rows[0]["BloodGroup"].ToString();
                lblGender.Text = dt.Rows[0]["Gender"].ToString();
                lblBagType.Text = dt.Rows[0]["BagType"].ToString();
                lblQty.Text = dt.Rows[0]["Quantity"].ToString();

                               mpeCreateGroup.Show();
                ddlCompleted.SelectedIndex = 2;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodgroup);
            BloodBank.bindType(ddlDonorType);
            ddlDonorType.Items.Insert(0, new ListItem("Select", "0"));
            ddlBloodgroup.Items.Insert(0, new ListItem("Select", "0"));
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            lblSession.Text = Session["Centre"].ToString();
            txtDonorId.Focus();
            BloodBank.bindBagType(ddlBagType);
            txtFromdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());//
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));

            //txtFromdate.SetCurrentDate();
            dtentry();
           // calfrom.EndDate = DateTime.Now;
           // calto.EndDate = DateTime.Now;

        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    private void clear()
    {
        txtDonorId.Text = "";
        txtName.Text = "";
        ddlBloodgroup.SelectedIndex = 0;
        txtTubeNo.Text = "";
        txtRemark.Text = "";
    }

    private void dtentry()
    {
        string str = "SELECT DATE_format(CollectedDate,'%d-%b-%Y')CollectedDate FROM bb_visitors_history ORDER BY id DESC LIMIT 1";
        lbldtentry.Text = Util.GetString(StockReports.ExecuteScalar(str));
    }

    private void saveCollectionRecord()
    {
        string BBTubeNo, volume, Remark, Doner, VisitID, BagType;
        int IsDonated, IsShocked,donationnotComplete;

        BBTubeNo = txtTubeNo.Text;

        Remark = txtRemark.Text;
        Doner = lblVisitorID1.Text;
        VisitID = lblVisitID.Text;
        BagType = ddlBagType.SelectedItem.Text;
        if (ddlCompleted.SelectedValue == "0")
        {
            IsDonated = 0;
            volume = "";
            donationnotComplete = 1;
        }
        else
        {
            if (ddlBagType.SelectedItem.Value == "1")
            {
                volume = ddlQty1.SelectedItem.Text;
            }
            else
                volume = ddlQty.SelectedItem.Text;
            IsDonated = 1;
            donationnotComplete = 0;
        }
        if (chkIsShocked.Checked == true)
        {
            IsShocked = 1;
        }
        else
        {
            IsShocked = 0;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string BloodCollectionId = "";
            string centerid = Session["Centre"].ToString();
            string id = "";
            
            
            if (ddlCompleted.SelectedValue == "0")
            {
                id = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Call bb_Collection_NA('" + centerid + "')"));
            }
            if (ddlCompleted.SelectedValue == "0")
            {
                BBTubeNo = id;
            }
            string bloodcollection_id = Util.GetString(StockReports.ExecuteScalar("select bloodcollection_id from bb_collection_details where visitor_id='" + Doner + "' and Visit_id='" + VisitID + "'"));
            if (bloodcollection_id.ToString() == "")
            {
                Blood_Collection blc = new Blood_Collection(tranX);
                blc.Visitor_Id = Doner;

                blc.BBTubeNo = BBTubeNo;

                blc.CollectedBy = ViewState["ID"].ToString();
                blc.CollectionRemark = Remark;
                blc.Visit_ID = VisitID;
                blc.Isdonated = IsDonated;
                blc.CentreID = Util.GetInt(ViewState["CenterID"]);
                blc.IsShocked = IsShocked;
                blc.volume = volume;
                blc.BagType = ddlBagType.SelectedItem.Text;
                // if (CheckDate())
                string date = Util.GetDateTime(txtFromdate.Text).ToString("yyyy-MM-dd");
                blc.CollectedDate = Convert.ToDateTime(date);


                BloodCollectionId = blc.Insert();
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE	bb_visitors_history SET BagType='" + ddlBagType.SelectedItem.Text + "' ,BloodCollection_Id='" + BloodCollectionId + "',IsDonated=" + IsDonated + ", BBTubeNo='" + BBTubeNo + "',volume='" + volume + "',CollectedRemarks='" + Remark + "',CollectedDate='" + Util.GetDateTime(txtFromdate.Text).ToString("yyyy-MM-dd") + "'  ,CollectedBy='" + ViewState["ID"].ToString() + "',IsDonationComplete='"+donationnotComplete+"' where Visit_ID='" + VisitID + "' ");
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE bb_collection_details SET BBTubeNo='" + BBTubeNo + "' ,BagType='" + ddlBagType.SelectedItem.Text + "' ,volume='" + ddlQty1.SelectedItem.Text + "' ,CollectionRemark='" + Remark + "' ,CollectedDate='" + Util.GetDateTime(txtFromdate.Text).ToString("yyyy-MM-dd") + "' ,IsDonated='" + IsDonated + "' WHERE BloodCollection_ID='" + bloodcollection_id + "'");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE	bb_visitors_history SET BagType='" + ddlBagType.SelectedItem.Text + "' , BloodCollection_Id='" + bloodcollection_id + "',IsDonated=" + IsDonated + ", BBTubeNo='" + BBTubeNo + "',volume='" + volume + "',CollectedRemarks='" + Remark + "',CollectedDate='" + Util.GetDateTime(txtFromdate.Text).ToString("yyyy-MM-dd") + "'  ,CollectedBy='" + ViewState["ID"].ToString() + "' ,IsDonationComplete='" + donationnotComplete + "' where Visit_ID='" + VisitID + "' ");
            }

            ExcuteCMD excuteCMD = new ExcuteCMD();

            int CheckMachinData = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*)d FROM mac_Data md WHERE md.`LabNo`='" + BloodCollectionId + "'"));
            if (CheckMachinData == 0)
            {
                DataTable dtMachine = StockReports.GetDataTable("SELECT * FROM bb_BloodTests_master WHERE id IN(1,2,3);");
                DataTable dtDonorDetail = StockReports.GetDataTable("SELECT * FROM bb_visitors bv WHERE Visitor_ID='" + Doner + "'");
                for (int i = 0; i < dtMachine.Rows.Count; i++)
                {
                    string sqlCMD = "INSERT INTO mac_data (BarcodeNo,centreid,LedgerTransactionNo,LabNo,Test_ID,LabObservation_ID,dtEntry,LabobservationName,InvestigationName,gender,age,pname)VALUES(@BarcodeNo,@centreid,@LedgerTransactionNo,@LabNo,@Test_ID,@LabObservation_ID,NOW(),@LabobservationName,@InvestigationName,@gender,@age,@pname)";

                    excuteCMD.DML(tranX, sqlCMD, CommandType.Text, new
                    {
                        BarcodeNo = BloodCollectionId,
                        centreid=Session["CentreID"].ToString(),
                       LedgerTransactionNo = BloodCollectionId,
                       LabNo = BloodCollectionId,
                       LabObservation_ID = dtMachine.Rows[i]["MachineId"].ToString(),
                       Test_ID = dtMachine.Rows[i]["ID"].ToString(),
                       LabobservationName = dtMachine.Rows[i]["MachineId"].ToString(),
                       InvestigationName = dtMachine.Rows[i]["TestName"].ToString(),
                       gender = dtDonorDetail.Rows[0]["Gender"].ToString(),
                       pname = dtDonorDetail.Rows[0]["NAME"].ToString(),
                       age = dtDonorDetail.Rows[0]["dtBirth"].ToString(),

                    });
                }

            }
            tranX.Commit();
           
            if (bloodcollection_id == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Sample Collection Successfully...Collection ID: " + BloodCollectionId + " ');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Sample Collection Updated Successfully...Collection ID: " + bloodcollection_id + " ');", true);
            }

            search();

            clear();
        }
        catch (Exception ex)
        {
                       // if (ex.InnerException.InnerException.Message.Contains("Duplicate entry"))
            if (ex.Message.Contains("Duplicate entry"))
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM203','" + Label1.ClientID + "');", true);
                //mpeCreateGroup.Show();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Tube Number is already used.',function(){var modal = $find('mpeCreateGroup'); modal.show();});", true);
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM124','" + lblMsg.ClientID + "');", true);

            tranX.Rollback();
           
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

  
    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT bv.Visitor_ID,bvh.Visit_ID,bvh.isFit,bvh.BagType,bvh.Quantity,bv.Name,bv.Gender,DATE_FORMAT(bv.dtEntry,'%d-%b-%y')dtEntry,bm.BloodGroup FROM bb_visitors bv  ");
            sb.Append(" INNER JOIN bb_visitors_history bvh ON bv.Visitor_ID=bvh.Visitor_ID LEFT OUTER JOIN bb_bloodgroup_master bm ON bm.Id=bv.BloodGroup_Id ");
            sb.Append(" WHERE isFit=1 AND IsDonated=0 AND bvh.CentreID=" + Util.GetInt(ViewState["CenterID"]) + " ");

            if (chkFailed.Checked)
            { sb.Append(" AND IsDonationComplete=1 "); }
            else { sb.Append(" AND IsDonationComplete=0 "); }
          

            if (txtDonorId.Text != "")
            {
                sb.Append("and bv.Visitor_ID='" + txtDonorId.Text + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" and bv.Name like '" + txtName.Text.Trim() + "%'");
            }
            if (ddlBloodgroup.SelectedIndex != 0)
            {
                sb.Append(" and bm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
            }
            if (ddlDonorType.SelectedIndex != 0)
            {
                sb.Append(" and bvh.Donationtype='" + ddlDonorType.SelectedValue + "'");
            }
            if (txtDonorId.Text == "" && txtName.Text == "" && ddlBloodgroup.SelectedIndex == 0)
            {
                if (txtdatefrom.Text != "")
                {
                    sb.Append(" AND DATE(bvh.dtEntry) >='" + Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (txtdateTo.Text != "")
                {
                    sb.Append(" and DATE(bvh.dtEntry) <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdDonor.DataSource = dt;
                grdDonor.DataBind();
                pnlHide.Visible = true;
            }
            else
            {
                grdDonor.DataSource = dt;
                grdDonor.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                pnlHide.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            grdDonor.DataSource = null;
            grdDonor.DataBind();
        }
    }

    private bool validation()
    {
        int bagtype = ddlBagType.SelectedIndex;
        if (bagtype == 0)
        {
            mpeCreateGroup.Show();
            Label1.Text = "Please Select BagType";
            return false;
        }
        if (bagtype == 1)
        {
            if (ddlQty1.SelectedItem.Text == "Select")
            {
                mpeCreateGroup.Show();
                Label1.Text = "Please Select Volume";
                return false;
            }
            else
            {
                return true;
            }
        }
        else
        {
            if (ddlQty.SelectedItem.Text == "Select")
            {
                mpeCreateGroup.Show();
                Label1.Text = "Please Select Volume";
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}