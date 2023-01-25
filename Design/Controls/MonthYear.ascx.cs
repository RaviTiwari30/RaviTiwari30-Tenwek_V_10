using System;

public partial class Design_Payroll_UserControl_MonthYear : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public void SetCurrentDate()
    {
        FillDatabaseDate(DateTime.Now.ToString());
    }
    public void SetDate(string day, string month, string year)
    {
        ddlDate.Text = day;
        ddlMonth.Text = month;
        ddlYear.Text = year;
    }
    public void FillDatabaseDate(string date)
    {
        if (date != string.Empty)
        {
            DateTime vDate = Convert.ToDateTime(date);
            SetDate(vDate.Day.ToString(), vDate.Month.ToString(), vDate.Year.ToString());
        }
    }
    public string GetDateForDataBase()
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
            return (ddlYear.SelectedValue + "-" + ddlMonth.SelectedValue + "-" + ddlDate.SelectedValue);
        else
            return string.Empty;
    }
    public string GetDateForDisplay()
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
            return (ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue);
        else
            return string.Empty;
    }
    public string GetDay()
    {
        return ddlDate.SelectedValue;
    }
    public string GetMonth()
    {
        return ddlMonth.SelectedValue;
    }
    public string GetYear()
    {
        return ddlYear.SelectedValue;
    }

    public void ClearDate()
    {
        ddlDate.SelectedIndex = 0;
        ddlMonth.SelectedIndex = 0;
        ddlYear.SelectedIndex = 0;
    }
    public bool IsLessOrEqualCurrentDate()
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) <= DateTime.Now)
                return true;

            return false;
        }
        return true;
    }
    public bool IsLessThanCurrentDate()
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) < DateTime.Now)
                return true;

            return false;
        }
        return true;
    }

    public bool IsMoreOrEqualCurrentDate()
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) >= DateTime.Now)
                return true;

            return false;
        }
        return true;
    }
    public bool IsMoreThanCurrentDate()
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) > DateTime.Now)
                return true;

            return false;
        }
        return true;
    }

    public bool IsLessOrEqualDate(DateTime date)
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) <= date)
                return true;

            return false;
        }
        return true;
    }
    public bool IsLessThanDate(DateTime date)
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) < date)
                return true;

            return false;
        }
        return true;
    }

    public bool IsMoreOrEqualDate(DateTime date)
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) >= date)
                return true;

            return false;
        }
        return true;
    }
    public bool IsMoreDate(DateTime date)
    {
        if ((ddlDate.SelectedValue != "-") && (ddlMonth.SelectedValue != "-") && (ddlYear.SelectedValue != "-"))
        {
            string vDate = ddlDate.SelectedValue + "-" + ddlMonth.SelectedItem.Text + "-" + ddlYear.SelectedValue;
            if (Convert.ToDateTime(vDate) > date)
                return true;

            return false;
        }
        return true;
    }
}
