using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for PreSurgeryBooking
/// </summary>
public class PreSurgeryBooking
{
    public PreSurgeryBooking()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public PreSurgeryBooking(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _Location;
    private string _HospCode;

    private DateTime _Date;
    private DateTime _Time;
    private string _Hospital_Id;
    private string _PatientID;
    private string _Pname;
    private string _PanelID;
    private string _CreatedBy;
    private string _DoctorID;
    private string _BillingCategoryID;
    private string _SurgeryID;
    private string _SurgeryName;
    private int _Quantity;
    private decimal _Amount;
    private string _TypeOfTnx;
    private string _PreSurgeryID;
    private string _ItemID;
    private string _ItemName;
    private string _SubCategoryID;
    private int _CentreID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string HospCode { get { return _HospCode; } set { _HospCode = value; } }

    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual DateTime Time { get { return _Time; } set { _Time = value; } }
    public virtual string Hospital_Id { get { return _Hospital_Id; } set { _Hospital_Id = value; } }
    public virtual string Pname { get { return _Pname; } set { _Pname = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual string BillingCategoryID { get { return _BillingCategoryID; } set { _BillingCategoryID = value; } }
    public virtual string SurgeryID { get { return _SurgeryID; } set { _SurgeryID = value; } }
    public virtual string SurgeryName { get { return _SurgeryName; } set { _SurgeryName = value; } }
    public virtual int Quantity { get { return _Quantity; } set { _Quantity = value; } }
    public virtual decimal Amount { get { return _Amount; } set { _Amount = value; } }
    public virtual string TypeOfTnx { get { return _TypeOfTnx; } set { _TypeOfTnx = value; } }
    public virtual string PreSurgeryID { get { return _PreSurgeryID; } set { _PreSurgeryID = value; } }
    public virtual string ItemID { get { return _ItemID; } set { _ItemID = value; } }
    public virtual string ItemName { get { return _ItemName; } set { _ItemName = value; } }
    public virtual string SubCategoryID { get { return _SubCategoryID; } set { _SubCategoryID = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            string Output = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_PreSurgeryBooking");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            //MySqlParameter Pre = new MySqlParameter();
            //Pre.ParameterName = "@_PreSurgeryID";

            //Pre.MySqlDbType = MySqlDbType.VarChar;
            //Pre.Size = 50;
            //Pre.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.Location = "PRE";
            this.HospCode = "SU";

            cmd.Parameters.Add(new MySqlParameter("@_Location", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@_HospCode", Util.GetString(HospCode)));
            cmd.Parameters.Add(new MySqlParameter("@_Hospital_Id", Util.GetString(Hospital_Id)));
            cmd.Parameters.Add(new MySqlParameter("@_CreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@_DoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@_PatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@_Pname", Util.GetString(Pname)));
            cmd.Parameters.Add(new MySqlParameter("@_PanelID", Util.GetString(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@_Date", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@_Time", Util.GetDateTime(Time)));
            cmd.Parameters.Add(new MySqlParameter("@_BillingCategoryID", Util.GetString(BillingCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@_SurgeryID", Util.GetString(SurgeryID)));
            cmd.Parameters.Add(new MySqlParameter("@_SurgeryName", Util.GetString(SurgeryName)));
            cmd.Parameters.Add(new MySqlParameter("@_Quantity", Util.GetInt(Quantity)));
            cmd.Parameters.Add(new MySqlParameter("@_Amount", Util.GetDecimal(Amount)));
            cmd.Parameters.Add(new MySqlParameter("@_PreSurgeryID", Util.GetInt(PreSurgeryID)));
            cmd.Parameters.Add(new MySqlParameter("@_ItemID", Util.GetString(ItemID)));
            cmd.Parameters.Add(new MySqlParameter("@_ItemName", Util.GetString(ItemName)));
            cmd.Parameters.Add(new MySqlParameter("@_SubCategoryID", Util.GetString(SubCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", Util.GetInt(CentreID)));
            Output = cmd.ExecuteNonQuery().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    #endregion All Public Member Function
}