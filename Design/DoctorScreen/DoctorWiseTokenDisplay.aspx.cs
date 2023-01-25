using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_DoctorScreen_DoctorWiseTokenDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            BindUser();
        }
    }

    private void BindUser()
    {
        DataView DoctorView = All_LoadData.bindDoctor().AsDataView();
        DoctorView.Sort = "Name ASC";
        DataTable dt = DoctorView.ToTable();
        if (dt.Rows.Count > 0)
        {
            cblUser.DataSource = dt;
            cblUser.DataTextField = "Name";
            cblUser.DataValueField = "DoctorID";
            cblUser.DataBind();
        }
    }

    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                // %27 is used to replace single code ('). Otherwise window.open function will not work. 
                if (str != string.Empty)
                    str += ",%27" + li.Value + "%27";
                else
                    str = "%27" + li.Value + "%27";
            }
        }

        return str;
    }

    protected void btnPreview_Click(object sender, EventArgs e)
    {
        string user = GetSelection(cblUser);      
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/DoctorScreen/AllDoctorDisplayScreen.aspx?DoctorId= " + user + " ');", true);
    }
}