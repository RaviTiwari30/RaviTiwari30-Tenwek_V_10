using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Xml.Linq;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.HtmlControls;

public partial class Design_DefaultHome : System.Web.UI.MasterPage
{
   
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Session["LoginType"] == null && Session["UserName"] == null)
        {
            Response.Redirect("~/Default.aspx");
        }
        Page.Header.DataBind();
        if (Request.ServerVariables["http_user_agent"].IndexOf
        ("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            Page.ClientTarget = "uplevel";
        }

        if (Request.ServerVariables["http_user_agent"].IndexOf
        ("chrome", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            Page.ClientTarget = "uplevel";
        }
        if (Session["LoginType"] == null && Session["UserName"] == null)
        {
            Response.Redirect("~/Default.aspx");
        }
    }

    protected override void Render(HtmlTextWriter writer)
    {
        // This code injects an IE compatibility meta tag into the page "head" section to resolve
        //   version incompatibility issues IE.
        //   This tag has to be injected at the very last moment before rendering the html
        //   because ASP.NET injects theme stylesheets that interfere with this tag.
        float ver;
        ver = getInternetExplorerVersion();
        if (ver > 0.0)
        {
            string meta;
            if (ver == 8.0)
            {
                meta = @" <meta http-equiv='X-UA-Compatible' content='IE=8'> ";
            }
            else if (ver == 9.0)
            {
                meta = @" <meta http-equiv='X-UA-Compatible' content='IE=8'> ";
            }
            else if (ver == 10.0)
            {
                meta = @" <meta http-equiv='X-UA-Compatible' content='IE=10'> ";
            }
            else if (ver == 11.0)
            {
                meta = @" <meta http-equiv='X-UA-Compatible' content='IE=10'> ";
            }
            else
            {
                meta = @" <meta http-equiv='X-UA-Compatible' content='IE=8'> ";
            }
            Literal ctrl = new Literal();
            ctrl.Text = meta;
            Page.Header.Controls.AddAt(0, ctrl);

            // Now continue with the page Render event

            // add the meta tag to head BEFORE the page starts rendering
        }
        base.Render(writer);



    }
    private float getInternetExplorerVersion()
    {
        // Returns the version of Internet Explorer or a -1
        // (indicating the use of another browser).
        float rv = 11;
        System.Web.HttpBrowserCapabilities browser = Request.Browser;

        string ClientBrowser = browser.Browser.Trim(); ;
        if (ClientBrowser == "IE" || ClientBrowser == "InternetExplorer")
        {
            rv = (float)(browser.MajorVersion);
        }
        return rv;
    }

    public class DefaultPageMaster
    {
        public string UserID { get; set; }
        public int roleID { get; set; }
        public string pageURL { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            if (Session["LoginType"] == null && Session["UserName"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                try
                {
                    //txtRoleID.Text = Session["RoleID"].ToString();
                    txtUid.Text = Session["ID"].ToString();
                    lblEmpName.Text = Util.GetString(Session["EmployeeName"]);
                    lblCenterName.Text = Util.GetString(Session["CentreName"]);
                    int CentreId = Util.GetInt(Session["CentreID"]);
                    lblLoginPanel.Text = Util.GetString(Session["LoginType"]);
                    lblRoleID.Text = Util.GetString(Session["RoleID"]);
                    lblUserID.Text = Util.GetString(Session["ID"]);
                    titleUser.Text = Resources.Resource.ApplicationName.Replace("/","").ToUpper() + "&nbsp;(" + Convert.ToString(Session["LoginName"]) + ") " + " (" + Util.GetString(lblLoginPanel.Text) + ")";
                    int IsExist = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_filemaster ps WHERE ps.URLName='" + HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1) + "' AND ps.Active=1 "));
                    if (Session["ID"].ToString() != "EMP001" && Session["ID"].ToString() != "LSHHI1240" && Session["ID"].ToString() != "LSHHI1248" && Session["ID"].ToString() != "LSHHI1244" && Session["ID"].ToString() != "822")
                    {
                        if (IsExist > 0)
                        {
                            if (All_LoadData.checkPageAuthorisation(Util.GetString(Session["RoleID"]), Util.GetString(Session["ID"]), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1),CentreId) == 0)
                            {
                                Response.Redirect("~/Welcome.aspx?IsAuthorize=1");
                           
                                return;
                            }
                            else
                            {
                                validateBindRoleAndMenu();
                            }
                        }
                        else
                        {
                            validateBindRoleAndMenu();
                        }
                    }
                    else
                    {
                        validateBindRoleAndMenu();
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
            }

            //string sqlCMD = "SELECT t.CentreID,cm.CentreName FROM (SELECT DISTINCT(f.CentreID) CentreID FROM f_login f  INNER JOIN employee_master em ON f.EmployeeID=em.Employee_ID WHERE em.IsActive=1 AND f.Active=1 AND f.EmployeeID=@userID ) t  INNER JOIN center_master cm ON t.CentreID=cm.CentreID ";
            //ExcuteCMD excuteCMD = new ExcuteCMD();
            //var userCenters = excuteCMD.GetDataTable(sqlCMD, CommandType.Text, new
            //{
            //    userID = Session["ID"].ToString()
            //});

            //ddlCenter.DataSource = userCenters;
            //ddlCenter.DataTextField = "CentreName";
            //ddlCenter.DataValueField = "CentreID";
            //ddlCenter.DataBind();
            //ddlCenter.SelectedIndex = ddlCenter.Items.IndexOf(ddlCenter.Items.FindByValue(Session["CentreID"].ToString()));

        }
        lblCenterName.Focus();
    }

    private void validateBindRoleAndMenu()
    {
        DataTable dt = All_LoadData.LoadRole(Util.GetString(HttpContext.Current.Session["id"]), Util.GetString(HttpContext.Current.Session["CentreID"].ToString()));
        rptRole.DataSource = dt;
        rptRole.DataBind();
        DataSet ds = new DataSet();
        ds.ReadXml(Server.MapPath("~/Design/MenuData/" + Util.GetString(Session["LoginType"]) + ".xml"));
        string AccessPath = Request.Url.AbsolutePath;
        AccessPath = AccessPath.Substring(AccessPath.IndexOf("/", 2));
        int isInMenuCount = ds.Tables["items"].AsEnumerable().Where(myRow =>
            myRow.Field<string>("urlname").ToString().ToLower() == AccessPath.ToLower()
            ).AsDataView().Count;
        if (Util.GetString(Session["ID"]) != "EMP001")
        {
            if (AccessPath != "/Welcome.aspx" && !ValidationSkipPage.ValidationSkipPages().Contains(AccessPath.ToLower()) && isInMenuCount < 1)
            {
                Response.Redirect("~/Welcome.aspx");
            }
        }

        
        string LoginType = Convert.ToString(Session["LoginType"]);
        try
        {
            var menuDataSet = new DataSet();
            menuDataSet.ReadXml(Server.MapPath("~/Design/MenuData/" + LoginType + ".xml"));
            var table = menuDataSet.Tables[0];
            if (table.Columns.Contains("image"))
            {
                rptMenu.DataSource = table;
                rptMenu.DataBind();
            }
            else
            {
                System.Data.DataColumn newColumn = new System.Data.DataColumn("image", typeof(System.String));
                newColumn.DefaultValue = "";
                table.Columns.Add(newColumn);
                rptMenu.DataSource = table;
                rptMenu.DataBind();
            }

            System.Xml.Serialization.XmlSerializer reader = new System.Xml.Serialization.XmlSerializer(typeof(List<DefaultPageMaster>));
            System.IO.StreamReader file = new System.IO.StreamReader(HttpContext.Current.Server.MapPath("~/Design/MenuData/Default/DefaultPageMaster.xml"));
            List<DefaultPageMaster> defaultPageMasterList = (List<DefaultPageMaster>)reader.Deserialize(file);
            file.Close();
            var defaultPage = defaultPageMasterList.Where(i => (i.roleID == Util.GetInt(lblRoleID.Text) && i.UserID == lblUserID.Text)).FirstOrDefault();
            if (defaultPage != null)
                linkRoleDefaultURL.Attributes.Add("href", Resources.Resource.ApplicationName + defaultPage.pageURL);
            else
                linkRoleDefaultURL.Style.Add("display", "none");


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void loadCookies(string RoleID, string Uid)
    {
        Response.Cookies.Add(new HttpCookie("Hospital", "CNS"));
        Response.Cookies.Add(new HttpCookie("RoleID", RoleID));
        Response.Cookies.Add(new HttpCookie("Uid", Uid));
    }

    protected void lnkSignOut_Click(object sender, EventArgs e)
    {
        UpdateLoginDetails();
        Session.RemoveAll();
        Session.Abandon();
        Response.Redirect("~/Default.aspx");
    }
    private void UpdateLoginDetails()
    {
        try
        {
            string str = "Update f_login Set LastLoginTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where EmployeeID='" + Session["ID"].ToString() + "' and RoleID='" + Session["RoleID"].ToString() + "' AND CentreID='" + Session["CentreID"].ToString() + "'";
            StockReports.ExecuteDML(str);
            StockReports.ExecuteDML("UPDATE online_employee set isActive=0,LogoutAt=NOW() where EmployeeID='" + Session["ID"].ToString() + "' and isActive=1");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void rptMenu_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Repeater Repeater2 = (Repeater)(e.Item.FindControl("rptSubMenu"));
            string LoginType = Convert.ToString(Session["LoginType"]);

            Label a1 = (Label)e.Item.FindControl("lblMenuID");
            var menuId = a1.Text;
            List<object> menuData = new List<object>();
            var parentDir = Resources.Resource.ApplicationName;
            XDocument document = XDocument.Load(Server.MapPath("~/Design/MenuData/" + LoginType + ".xml"));
            var menuList = document.Descendants("NewDataSet").Descendants("Menu").Descendants("Items").Select(d =>
                            new
                            {
                                MenuID = d.Element("MenuID").Value,
                                MenuDisplayName = d.Element("DispName").Value,
                                MenuURL = parentDir + d.Element("URLName").Value

                            }).Where(m => m.MenuID == menuId).ToList();


            Repeater2.DataSource = menuList;
            Repeater2.DataBind();
        }
    }

    //protected void Image_Click(object sender, CommandEventArgs e)
    //{
    //    if (e.CommandName == "ImageClick")
    //    {
    //        //e.CommandArgument -->  photoid value
    //        //Do something
    //    }
    //}

    protected void rptRole_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Select")
        {
            var role = Util.GetString(e.CommandArgument).Split('#');

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.RoleID,rm.DeptLedgerNo,rm.IsStore FROM f_login fl INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID");
            sb.Append(" WHERE fl.Active = 1 AND fl.RoleID = " + role[1].ToString() + " AND fl.EmployeeId = '" + Util.GetString(Session["ID"]) + "' AND fl.CentreID=" + Session["CentreID"] + "");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                Session.Remove("DeptLedgerNo");
                Session["LoginType"] = role[0].ToString();
                Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                Session["DeptLedgerNo"] = dt.Rows[0]["DeptLedgerNo"].ToString();
                Session["IsStore"] = dt.Rows[0]["IsStore"].ToString();
                Response.Redirect("~/Welcome.aspx");
            }
        }
    }


    //protected void ddlCenter_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    Session["CentreID"] = ddlCenter.SelectedValue;
    //    validateBindRoleAndMenu();
    //}
}
