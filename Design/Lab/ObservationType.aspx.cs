using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class Design_Lab_ObservationType : System.Web.UI.Page
{
    string Creator_Id;
    static int iFlag = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (IsPostBack == false)
            {
                Creator_Id = Session["ID"].ToString();
                
                
                txtName.Focus();
                BindCategory();
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    private void BindCategory()
    {
      DataTable category=StockReports.GetDataTable("  SELECT cm.CategoryID,cm.Name FROM f_configrelation c "+
                          " INNER JOIN f_categorymaster cm ON c.CategoryID= cm.Categoryid WHERE c.configID='3' AND cm.Active='1' ");
      if (category.Rows.Count > 0)
      {
          ddlCategory.DataSource = category;
          ddlCategory.DataTextField = "Name";
          ddlCategory.DataValueField = "CategoryID";
          ddlCategory.DataBind();
      }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtName.Text.Trim() == "" || txtName.Text == null)
        {
            lblMsg.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM049','" + lblMsg.ClientID + "');", true);
            return;
        }
        //if (logoFIleUpload.HasFile)
        //{
        //    string Ext = System.IO.Path.GetExtension(logoFIleUpload.FileName);
        //    if (Ext != ".jpg")
        //    {
        //        lblMsg.Visible = true;
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblMsg.ClientID + "');", true);
        //        return;
        //    }

        //}
        //else
        //{
        //    lblMsg.Visible = true;
        //    lblMsg.Text = "Please Upload Department Logo";
        //    return;
        //}
        try
        {

            string str = "Select Name from observationtype_master where Replace(Name,' ','') = '" + (txtName.Text.Trim()).Replace(" ", "") + "'";
            DataTable dt = StockReports.GetDataTable(str.ToString());

            if (dt.Rows.Count > 0)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Name Already Exist";
                iFlag = 1;
                grdObservationType.Visible = true;
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            ObservationType_Master objObservationType_Master = new ObservationType_Master(tnx);
            objObservationType_Master.Creator_ID = Creator_Id;
            objObservationType_Master.Name = txtName.Text.Trim();
            objObservationType_Master.Description = txtDesc.Text.Trim();
            objObservationType_Master.DeptEmailID = txtEmailID.Text;
            if (chkTemplateType.Checked)
            {
                objObservationType_Master.Flag = 3;
            }
            string observationtypeID = objObservationType_Master.Insert();
            if (observationtypeID == "")
            {
                tnx.Rollback();
                return;
            }
            //if (logoFIleUpload.HasFile)
            //{
            //    string Ext = System.IO.Path.GetExtension(logoFIleUpload.FileName);
            //    if (Ext != ".jpg")
            //    {
            //        lblMsg.Visible = true;
            //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblMsg.ClientID + "');", true);
            //        return;
            //    }
            //    string directoryPath = Server.MapPath("~/DepartmentLogo");
            //    if (!Directory.Exists(directoryPath))
            //    {
            //        Directory.CreateDirectory(directoryPath);
            //    }
            //    string filePath = Path.Combine(directoryPath, logoFIleUpload.FileName);
            //    //  logoFIleUpload.SaveAs(filePath);
            //    string filePathNew = Server.MapPath("~/DepartmentLogo/") + observationtypeID + System.IO.Path.GetExtension(filePath);
            //    if (File.Exists(filePathNew))
            //    {
            //        File.Delete(filePathNew);
            //    }
            //    logoFIleUpload.SaveAs(filePathNew);



            //}
            //else
            //{
            //    lblMsg.Visible = true;
            //    lblMsg.Text = "Please Upload Logo";
            //    return;
            //}

            string Saved = CreateStockMaster.SaveSubCategoryDetails(txtName.Text, txtDesc.Text, ddlCategory.SelectedValue, tnx);
            //update SubcategoryID to observationtype_master
            if (Saved == "")
            {
                tnx.Rollback();
                return;
            }
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update observationtype_master set Description='" + Saved + "',DeptDescription='"+txtDesc.Text.Trim()+"' where observationtype_ID='" + observationtypeID + "'");
            if (Saved == "")
            {
                tnx.Rollback();
                return;
            }
            lblMsg.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            tnx.Commit();
            Clear();
            LoadCacheQuery.dropCache("SubCategory");
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = ex.Message.ToString();
            return;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (btnClear.Text == "Clear")
        {
            Clear();
        }
        else if (btnClear.Text == "Add New")
        {
            btnClear.Text = "Clear";
            btnSave.Enabled = true;
            Clear();
           
            txtName.Focus();
            iFlag = 0;
        }
        else
        {
            txtDesc.Text = "";
            txtName.Text = "";
            chkTemplateType.Checked = false;
        }
    }
    private void BindObservationType(int Flag)
    {
        try
        {
           
            string str = "";
            if (Flag == 0)
            {
                str = "Select Name,Description,Type,Flag,ObservationType_ID,Creator_ID,GroupID from observationtype_master where flag=0 order by Name";
            }
            else if (Flag == 1)
            {
                str = "Select Name,Description,Type,Flag,ObservationType_ID ,Creator_ID,GroupID from observationtype_master where Name like ";
                if (txtSearchName.Text != "")
                {
                    str = str + "'" + txtSearchName.Text.Trim() + "%' order by Name";
                }
            }
            DataTable dt = StockReports.GetDataTable(str.ToString());
            grdObservationType.DataSource = dt;
            grdObservationType.DataBind();
        }

        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void Clear()
    {
        txtName.Text = "";
        txtDesc.Text = "";
        txtEmailID.Text = "";
        chkTemplateType.Checked = false;
    }
    
    
   
  
    protected void grdObservationType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "AView")
        {
            try
            {
                string Path = "~/DepartmentLogo";
                bool IsExists = System.IO.Directory.Exists(Server.MapPath(Path));
                if (!IsExists)
                {
                    System.IO.Directory.CreateDirectory(Server.MapPath(Path));
                }
                string url = Server.MapPath("~/DepartmentLogo/" + e.CommandArgument + ".jpg");
                if (File.Exists(url))
                {
                    lblMsg.Text = "";
                    Response.AddHeader("content-disposition", @"attachment; filename=" + e.CommandArgument + ".jpg");
                    Response.ContentType = "image / jpeg";
                    Response.WriteFile(url);
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    lblMsg.Text = "Please Upload The Header";
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.Message;
              
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return;
            }
        }
        if (e.CommandName == "imbRemove")
        {
            string Observation = Util.GetString(e.CommandArgument).Split('#')[0];
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            int RowsUpdated = 0;
            try
            {
                string sql = "Update observationtype_master set flag=1 WHERE ObservationType_ID='" + Observation + "'";
                RowsUpdated = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);
                Tranx.Commit();
                BindObservationType(iFlag);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Removed Successfully');", true);
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
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
    }
    protected void grdObservationType_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        grdObservationType.EditIndex = -1;
        BindObservationType();
    }
    protected void grdObservationType_RowEditing(object sender, GridViewEditEventArgs e)
    {
        grdObservationType.EditIndex = (int)e.NewEditIndex;
        BindObservationType();
        ((TextBox)grdObservationType.Rows[e.NewEditIndex].Cells[1].Controls[0]).MaxLength = 50;
    }
    protected void grdObservationType_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string HID = Util.GetString(Session["HOSPID"].ToString());
        ObservationType_Master objObstypemaster = new ObservationType_Master();
        objObstypemaster.ObservationType_ID = ((Label)grdObservationType.Rows[e.RowIndex].Cells[8].FindControl("lblObservationtype_ID")).Text;
        objObstypemaster.Name = ((TextBox)grdObservationType.Rows[e.RowIndex].Cells[1].Controls[0]).Text;
        objObstypemaster.Description = ((Label)grdObservationType.Rows[e.RowIndex].FindControl("lblDesc")).Text;
        //objObstypemaster.Type = ((TextBox)grdObservationType.Rows[e.RowIndex].Cells[2].Controls[0]).Text;
        // objObstypemaster.Flag = Util.GetInt(((TextBox)grdObservationType.Rows[e.RowIndex].Cells[3].Controls[0]).Text);
        RadioButtonList flg = ((RadioButtonList)grdObservationType.Rows[e.RowIndex].FindControl("rbtFlag"));
        string Flag = flg.SelectedItem.Value;
        if (Flag.ToUpper() == "YES")
            Flag = "3";
        else
            Flag = "0";
        objObstypemaster.Flag = Util.GetInt(Flag);
        objObstypemaster.Print_Sequence = Util.GetInt(((TextBox)grdObservationType.Rows[e.RowIndex].Cells[2].Controls[0]).Text);
        objObstypemaster.Creator_ID = grdObservationType.Rows[e.RowIndex].Cells[4].Text.ToString();
        objObstypemaster.GroupID = grdObservationType.Rows[e.RowIndex].Cells[5].Text.ToString();
        RadioButtonList rbt = ((RadioButtonList)grdObservationType.Rows[e.RowIndex].FindControl("rbtActive"));
        string IsActive = rbt.SelectedItem.Value;
        if (IsActive.ToUpper() == "YES")
            IsActive = "1";
        else
            IsActive = "0";
        objObstypemaster.IsActive = Util.GetInt(IsActive);

        if (((FileUpload)grdObservationType.Rows[e.RowIndex].FindControl("fuLogo")).HasFile)
        {
            string Ext = System.IO.Path.GetExtension(((FileUpload)grdObservationType.Rows[e.RowIndex].FindControl("fuLogo")).FileName);
            if (Ext != ".jpg")
            {
                lblMsg.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('MM051','" + lblMsg.ClientID + "');", true);
                return;
            }
            string directoryPath = Server.MapPath("~/DepartmentLogo");
            if (!Directory.Exists(directoryPath))
            {
                Directory.CreateDirectory(directoryPath);
            }
            string filePath = Path.Combine(directoryPath, ((FileUpload)grdObservationType.Rows[e.RowIndex].FindControl("fuLogo")).FileName);

            string filePathNew = Server.MapPath("~/DepartmentLogo/") + ((Label)grdObservationType.Rows[e.RowIndex].Cells[8].FindControl("lblObservationtype_ID")).Text + System.IO.Path.GetExtension(filePath);
            if (File.Exists(filePathNew))
            {
                File.Delete(filePathNew);
            }
            ((FileUpload)grdObservationType.Rows[e.RowIndex].FindControl("fuLogo")).SaveAs(filePathNew);
        }

        objObstypemaster.Update();
        StockReports.ExecuteScalar("update f_subcategorymaster set name='" + objObstypemaster.Name + "',Active='" + IsActive + "' where subcategoryid='" + objObstypemaster.Description + "'");
        grdObservationType.EditIndex = -1;
        BindObservationType();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
        con.Close();
        con.Dispose();
    }

    protected void lnkView_Click(object sender, EventArgs e)
    {
        iFlag = 0;
        txtSearchName.Text = "";
        grdObservationType.Visible = false;
        grdObservationType.Controls.Clear();

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        BindObservationType();
        grdObservationType.Visible = true;
    }
    private void BindObservationType()
    {
        string str = "";
        //str = "Select DISTINCT UPPER(ot.Name)Name,ot.Description,ot.Type,if(ot.Flag=3,'Yes','No')Flag,ot.ObservationType_ID ,ot.Creator_ID,ot.GroupID,if(IsActive=1,'Yes','No')IsActive,ot.Print_Sequence FROM investigation_master im INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID right outer JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id";
        //if (txtSearchName.Text != "")
        //{
        //    str = str + " WHERE ot.Name like '" + txtSearchName.Text.Trim() + "%' ";
        //}
        //if (Session["LoginType"].ToString().ToUpper() == "RADIOLOGY")
        //    str += "  and im.ReportType=5 ORDER BY ot.Name ";
        //else
        //    str += "  and im.ReportType<>5 ORDER BY ot.Name ";

     str= @"   SELECT DISTINCT UPPER(ot.Name)NAME,ot.Description,ot.Type,IF(ot.Flag=3,'Yes','No')Flag,ot.ObservationType_ID ,ot.Creator_ID,
ot.GroupID,IF(IsActive=1,'Yes','No')IsActive,ot.Print_Sequence FROM observationtype_master ot
INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=ot.`Description` ";
                if (txtSearchName.Text != "")
        {
            str = str + " WHERE ot.Name LIKE '" + txtSearchName.Text.Trim() + "%' ";
        }
        if (Session["LoginType"].ToString().ToUpper() == "RADIOLOGY")
            str += "   AND sc.`CategoryID`=7 ORDER BY ot.Name ";
        else
            str += "   AND sc.`CategoryID`=3  ORDER BY ot.Name ";
 
 
        DataTable dt = StockReports.GetDataTable(str.ToString());
        grdObservationType.DataSource = dt;
        grdObservationType.DataBind();
    }
}
