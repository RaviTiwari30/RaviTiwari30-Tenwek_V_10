using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using System.IO;

public partial class Design_EDP_FileManager : System.Web.UI.Page
{
    protected void btnFile_Click(object sender, EventArgs e)
    {
        FileMaster();
    }

    protected void btnFileSave_Click(object sender, EventArgs e)
    {
        string str = "insert into f_filemaster(URLName,DispName,MenuID,Description) values('" + txtURL.Text.Trim() + "','" + txtdispName.Text.Trim() + "'," + ddlNfile.SelectedValue + ",'" + txtFDesc.Text.Trim() + "')";
        if (StockReports.ExecuteDML(str))
        {
            lblMsg.Text = "Record Saved Successfully";
            txtDesc.Text = string.Empty;
            txtURL.Text = string.Empty;
            txtdispName.Text = string.Empty;
        }
        else
            lblMsg.Text = "Error occurred, Please contact administrator";
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string str = string.Empty;
        int Active = 0;
        if (rdbActive.Checked == true)
        {
            Active = 1;
        }
        else
        {
            Active = 0;
        }
        str = "update f_filemaster set Description='" + txtDesc.Text.Trim() + "',MenuID=" + ddlMenu1.SelectedValue + ",Active=" + Active + " where ID=" + lblFileId.Text + "";
        if (StockReports.ExecuteDML(str))
        {
            lblMsg.Text = "Record Updated Successfully";
            txtDesc.Text = "";
            FileMaster();
        }
        else
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
        }
    }

    protected void btnSaveMnu_Click(object sender, EventArgs e)
    {
        string str = string.Empty;
        if (lblmenuid.Text == string.Empty)
        {
            if (!fileuploadmenu.HasFile)
            {
                lblMsg.Text = "Please Select the file";
            }
            else
            {
                System.IO.Stream fs = fileuploadmenu.PostedFile.InputStream;
                System.IO.BinaryReader br = new System.IO.BinaryReader(fs);
                Byte[] bytes = br.ReadBytes((Int32)fs.Length);
                string base64image = Convert.ToBase64String(bytes, 0, bytes.Length);
                //string base64image = this.PhotoBase64ImgSrc(fileuploadmenu.ToString());
                str = "insert into  f_menumaster(MenuName,image,LastUpdatedBy,UpdateDate,IPAddress) values('" + txtNMenu.Text.Trim() + "','" + string.Format("data:image/jpg;base64,{0}", base64image) + "','"+ Session["ID"].ToString() +"',NOW(),'"+ All_LoadData.IpAddress() +"')";
                if (StockReports.ExecuteDML(str))
                {
                    lblMsg.Text = "Record Saved Successfully";
                    BindMenu();
                    txtNMenu.Text = string.Empty;
                }
                else
                    lblMsg.Text = "Error...";
            }
        }
        else
        {
            string base64image = string.Empty;
            if (fileuploadmenu.HasFile)
            {
                System.IO.Stream fs = fileuploadmenu.PostedFile.InputStream;
                System.IO.BinaryReader br = new System.IO.BinaryReader(fs);
                Byte[] bytes = br.ReadBytes((Int32)fs.Length);
                base64image = Convert.ToBase64String(bytes, 0, bytes.Length);
            }
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE f_menumaster SET MenuName = '" + txtNMenu.Text.Trim() + "' ");
            if (base64image != string.Empty)
            {
                sb.Append(" ,image='" + string.Format("data:image/jpg;base64,{0}", base64image) + "' ");
            }
            sb.Append(",LastUpdatedBy='"+ Session["ID"].ToString() +"',UpdateDate=NOW(),IPAddress='"+ All_LoadData.IpAddress() +"' ");
            sb.Append("WHERE ID='" + lblmenuid.Text.Trim() + "' ");
            if (StockReports.ExecuteDML(sb.ToString()))
            {
                lblMsg.Text = "Record Updated Successfully";
                BindMenu();
                txtNMenu.Text = string.Empty;
            }
            else
                lblMsg.Text = "Error...";
        }
    }
    
    protected void grdFile_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            int Index = Util.GetInt(e.CommandArgument);
            int FileId = Util.GetInt((((Label)grdFile.Rows[Index].FindControl("lblID")).Text));
            DataTable dt = new DataTable();
            if (ViewState["File"] != null)
            {
                dt = (DataTable)ViewState["File"];
            }
            DataRow[] dr = dt.Select("ID='" + FileId + "'");
            if (dr.Length > 0)
            {
                txtDesc.Text = Util.GetString(dr[0]["Description"]);
                lblFileName.Text = Util.GetString(dr[0]["DispName"]);
                lblFileId.Text = Util.GetString(dr[0]["ID"]);
            }
            BindMenu1();
            mpeCreateGroup.Show();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindMenu();
            FileMaster();
        }
    }

    private void BindMenu()
    {
        DataTable dt = All_LoadData.LoadHISMenu();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlMenu.DataSource = dt;
            ddlMenu.DataTextField = "MenuName";
            ddlMenu.DataValueField = "ID";
            ddlMenu.DataBind();

            ddlNfile.DataSource = dt;
            ddlNfile.DataTextField = "MenuName";
            ddlNfile.DataValueField = "ID";
            ddlNfile.DataBind();
        }
        ddlMenu.Items.Insert(0, new ListItem("No Menu", "0"));
    }

    private void BindMenu1()
    {
        string str = "select ID,MenuName from f_menumaster";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlMenu1.DataSource = dt;
            ddlMenu1.DataTextField = "MenuName";
            ddlMenu1.DataValueField = "ID";
            ddlMenu1.DataBind();
        }
    }

    private void FileMaster()
    {
        StringBuilder sb = new StringBuilder();
        if (ddlMenu.SelectedValue == "0")
        {
            sb.Append(" select FM.ID,FM.DispName,FM.Description,MM.MenuName from f_filemaster  FM ");
            sb.Append(" left join f_menumaster MM on FM.MenuID=MM.ID where FM.active=1 and FM.menuid =0");
        }
        else
        {
            sb.Append(" select FM.ID,FM.DispName,FM.Description,MM.MenuName from f_filemaster  FM ");
            sb.Append(" left join f_menumaster MM on FM.MenuID=MM.ID where FM.active=1 and FM.menuid =" + ddlMenu.SelectedValue + "");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdFile.DataSource = dt;
            grdFile.DataBind();
            ViewState.Add("File", dt);
        }
        else
        {
            grdFile.DataSource = null;
            grdFile.DataBind();
        }
    }
}