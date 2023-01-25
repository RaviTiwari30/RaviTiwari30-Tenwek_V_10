using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Masters_Insurance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            //ucDateFrom.FillDatabaseDate(DateTime.Now.ToString());
            //ucDateto.FillDatabaseDate(DateTime.Now.ToString());
            bindprovider();
            bindasset();
            bindins();
            lblMsg.Text = "";
        }
       
    }

    private void bindins()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT im.id, policyno,NAME,insval, DATE_FORMAT(Ins_startdate,'%d-%m-%Y')sdate,DATE_FORMAT(ins_enddate,'%d-%m-%Y')edate
 ,(CASE WHEN STATUS=1 THEN 'True' ELSE 'false' END) STATUS FROM eq_insurance_master im INNER JOIN eq_providerinsurance epi ON im.insproid=epi.id  ");

        grdAsset.DataSource = dt;
        grdAsset.DataBind();
       

       
        
    }
    private void bindprovider()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT NAME,id FROM eq_providerinsurance WHERE isactive=1 AND providertype='INS' ");
        ddlpro.DataSource = dt;

        ddlpro.DataTextField = "name";
        ddlpro.DataValueField = "id";
        ddlpro.DataBind();

        ddlpro.Items.Insert(0, new ListItem("Select", "Select"));
        ddlpro.SelectedIndex = 0;

    }
    private void bindasset()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(id,'#',assetcode) id,itemname FROM eq_asset_master WHERE isactive='1' ");

        ddlasset.DataSource = dt;
        ddlasset.DataTextField = "Itemname";
        ddlasset.DataValueField = "id";
        ddlasset.DataBind();
    
        ddlasset.Items.Insert(0,new ListItem("Select", "Select"));
        ddlasset.SelectedIndex = 0;

    }

    bool checkduplicate()
    {
        foreach (GridViewRow dw in grasset.Rows)
        {
            Label lb = (Label)dw.FindControl("lbid");
            if (lb.Text == ddlasset.SelectedValue.Split('#')[0].ToString())
            {
                return true;
            }
            else
            {
                return false;
            }
            
        }
        return false;
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (checkduplicate())
        {
            lblMsg.Text = "Asset Alredy Added";
            return;
        }

        DataTable dt;
        if (ViewState["dtasset"] != null)
        {
            dt = (DataTable)ViewState["dtasset"];
        }
        else
        {
            dt = createtable();
        }

        DataRow dw = dt.NewRow();

        dw["AssetId"] = ddlasset.SelectedValue.Split('#')[0].ToString();
        dw["AssetCode"] = ddlasset.SelectedValue.Split('#')[1].ToString();
        dw["AssetName"] = ddlasset.SelectedItem.Text;
        dw["Description"] = txtdes.Text;
        dt.Rows.Add(dw);

        grasset.DataSource = dt;
        grasset.DataBind();
        ViewState["dtasset"]=dt;
        txtdes.Text = "";
        ddlasset.SelectedIndex = 0;
    }

    DataTable createtable()
   {
       DataTable dt = new DataTable();
       dt.Columns.Add("AssetId");
       dt.Columns.Add("AssetCode");
       dt.Columns.Add("AssetName");
       dt.Columns.Add("Description");
       return dt;

   }
    protected void grdAsset_RowCommand(object sender, GridViewCommandEventArgs e)
    {
//        string id = Util.GetString(e.CommandArgument);

//        if (e.CommandName == "EditData")
//        {
//            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_insurance_master WHERE id='" + id + "'");
//            if (dt != null && dt.Rows.Count > 0)
//            {
//                txtpolicyno.Text = dt.Rows[0]["Policyno"].ToString();
//                txtinc .Text=dt.Rows[0][3].ToString();
//                txtenc.Text =dt.Rows[0][4].ToString();
//                ucDateFrom.FillDatabaseDate(dt.Rows[0][5].ToString());
//                ucDateto.FillDatabaseDate(dt.Rows[0][6].ToString());
//                txtval .Text =dt.Rows[0][7].ToString();
//                ViewState["uid"] = dt.Rows[0][0].ToString();
//                ddlpro.SelectedValue = dt.Rows[0][2].ToString();
//                if (dt.Rows[0]["status"].ToString() == "1")
//                {
//                    chk.Checked = true;
//                }
//                else
//                {
//                    chk.Checked = false;
//                }

//                DataTable dtt = StockReports.GetDataTable("SELECT AssetId,description,assetcode,itemname assetname FROM eq_insurance_detail eid INNER JOIN eq_asset_master eam ON eid.assetid=eam.id WHERE eid.INSURENCEID='" + id + "'");
//                ViewState["dtasset"] = dtt;
//                grasset.DataSource = dtt;
//                grasset.DataBind();
//                btnsave.Text = "Update";

//            }
//        }
//        else if (e.CommandName == "ViewLog")
//        {
//            lblLog.Text = StockReports.ExecuteScalar(@"SELECT CONCAT('Insert By-',em.Name,' Insert Date- ',DATE_FORMAT(insertdate,'%d-%m-%Y')) insertBy  FROM eq_asset_master ps 
//INNER JOIN employee_master em ON em.employee_id=ps.insertby WHERE ps.id=" + id);
            
//            mdpLog.Show();

//        }
    }
    protected void grasset_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtasset"];
            dtItem.Rows[index].Delete();
            dtItem.AcceptChanges();
            ViewState["dtasset"] = dtItem;
            grasset.DataSource = dtItem;
            grasset.DataBind();
        }
    }
    protected void btnsave_Click1(object sender, EventArgs e)
    {
        if (grasset.Rows.Count == 0)
        {
            lblMsg.Text = "Select Asset";
            return;

        }

        savedata();

        bindins();

    }

    void savedata()
    {
        //MySqlConnection conn = Util.GetMySqlCon();
        //conn.Open();

        //if (btnsave.Text == "Save")
        //{
        //    try
        //    {
        //        string str = "";
        //        string filename = "";
        //        if (FileUpload1.HasFile)
        //        {
        //            filename = FileUpload1.PostedFile.FileName;
        //            FileUpload1.SaveAs(Server.MapPath("~/Design/Equipment/Attachment/"+FileUpload1 .FileName));
        //        }
        //        int IsActive = 0;

        //        if (chk.Checked)
        //            IsActive = 1;
                

        //        str = "INSERT INTO eq_insurance_master(PolicyNo,InsproId,Inclusion,Exclusion,Ins_startdate,ins_enddate,filename,STATUS,insertby,insertdate,ipnumber,insval)";
        //        str += "values('" + txtpolicyno.Text + "','" + ddlpro.SelectedValue + "','" + txtinc.Text + "','" + txtenc.Text + "','" + (Util.GetDateTime(ucDateFrom.GetDateForDisplay())).ToString("yyyy-MM-dd") + "',";
        //        str += " '" + (Util.GetDateTime(ucDateto.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','" + filename + "','" + IsActive + "','" + ViewState["ID"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + txtval.Text + ")";


        //        StockReports.ExecuteDML(str);

        //        string insid = StockReports.ExecuteScalar("Select max(id) from eq_insurance_master");
        //        foreach (GridViewRow dw in grasset.Rows)
        //        {
        //            Label lb = (Label)dw.FindControl("lbid");
        //            Label lb1 = (Label)dw.FindControl("lbdes");
        //            string query = "insert into eq_insurance_detail(INSURENCEID,Assetid,Description) values ('" + insid + "','" + lb.Text + "','" + lb1.Text + "')";
        //            StockReports.ExecuteDML(query);
        //        }


        //        conn.Close();
        //        conn.Dispose();

        //        lblMsg.Text = "Record Saved";

        //        btnsave.Text = "Save";

        //        bindasset();


        //    }
        //    catch (Exception ex)
        //    {

        //        conn.Close();
        //        conn.Dispose();

        //        ClassLog cl = new ClassLog();
        //        cl.errLog(ex);
        //        lblMsg.Text = ex.Message;
        //    }
        //}



        //else
        //{
        //    try
        //    {
        //        string str = "";
        //        string filename = "";
        //        if (FileUpload1.HasFile)
        //        {
        //            filename = FileUpload1.PostedFile.FileName;
        //            FileUpload1.SaveAs(Server.MapPath("~/Design/Equipment/Attachment/" + FileUpload1.FileName));
        //        }
        //        int IsActive = 0;

        //        if (chk.Checked)
        //            IsActive = 1;








        //        str = @"update eq_insurance_master set policyno='" + txtpolicyno.Text + "',insproid='" + ddlpro.SelectedValue + "',inclusion='" + txtinc.Text + "',exclusion='" + txtenc.Text + "',Ins_startdate='" + (Util.GetDateTime(ucDateFrom.GetDateForDisplay())).ToString("yyyy-MM-dd") + "',ins_enddate='" + (Util.GetDateTime(ucDateto.GetDateForDisplay())).ToString("yyyy-MM-dd") + "',status='" + IsActive + "',insval='" + txtval.Text + "',updateby='" + ViewState["ID"].ToString() + "',updatetime=Now() where id='" + ViewState["uid"].ToString() + "'";


        //        StockReports.ExecuteDML(str);

               
               
        //            if (filename != "")
        //            {
        //                str = "update table eq_insurance_master set filename='" + filename + "' where id=" + ViewState["uid"].ToString() + "'";
        //                StockReports.ExecuteDML(str);
        //            }

        //            str = "delete from eq_insurance_detail where INSURENCEID='" + ViewState["uid"].ToString() + "'";
        //            StockReports.ExecuteDML(str);
              
        //        foreach (GridViewRow dw in grasset.Rows)
        //        {
        //            Label lb = (Label)dw.FindControl("lbid");
        //            Label lb1 = (Label)dw.FindControl("lbdes");
        //            string query = "insert into eq_insurance_detail(INSURENCEID,Assetid,Description) values ('" + ViewState["uid"].ToString() + "','" + lb.Text + "','" + lb1.Text + "')";
        //            StockReports.ExecuteDML(query);
        //        }


        //        conn.Close();
        //        conn.Dispose();

        //        lblMsg.Text = "Record Updated";

        //        btnsave.Text = "Save";

        //        bindasset();


        //    }
        //    catch (Exception ex)
        //    {

        //        conn.Close();
        //        conn.Dispose();

        //        ClassLog cl = new ClassLog();
        //        cl.errLog(ex);
        //        lblMsg.Text = ex.Message;
        //    }
        //}
    }

    void clearcontrol()
    {
        //txtpolicyno.Text = "";
        //txtenc.Text = "";
        //txtinc.Text = "";
        //txtval.Text = "";
        //txtdes.Text = "";
        //ddlpro.SelectedIndex = 0;
        //ddlasset.SelectedIndex = 0;
        //grasset.DataSource = null;
        //grasset.DataBind();
        //ucDateFrom.FillDatabaseDate(DateTime.Now.ToString());
        //ucDateto.FillDatabaseDate(DateTime.Now.ToString());


    }
    protected void btnclear_Click(object sender, EventArgs e)
    {
        clearcontrol();
        btnsave.Text = "Save";
    }
}