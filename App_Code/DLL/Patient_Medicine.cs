#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces

/// <summary>
/// Summary description for Patient_Medicine
/// </summary>
public class Patient_Medicine
{
    #region All Memory Variables
    private int _PatientMedicine_ID;
    private string _TransactionID;
    private string _Medicine_ID;
    private string _NoOfDays;
    private string _NoTimesDay;
    private string _Dose;
    private int _Outsource;
    private string _Remarks;
    private int _Ischange;
    private string _MedicineName;
    private int _isEmergency;
    private int _centreID;
    private string _Hospital_ID;
    private int _Quantity;
    private string _Unit;
    private string _IntervalId;
    private string _IntervalName;
    private string _DurationName;
    private string _DurationVal;
    private string _TimetoGive;
    private string _RefealVal;
    private string _RefealTillDate;

    private int _DocDepartmentId;
    private int _DocRoleId;
    private string _DeptLedgerNo;









   [System.ComponentModel.DefaultValue(0)]
    private string _DoctorID;
    private string _Route;
    private string _prescribedItemID;
    private string _Dept;
    [System.ComponentModel.DefaultValue(0)]
    private int _App_ID;

    [System.ComponentModel.DefaultValue(0)]
    private int _IsEmergencyData;
    private int _IsIPDData;

    public int Ischange
    {
        get { return _Ischange; }
        set { _Ischange = value; }
    }
    private string _ChangeReason;

    public string ChangeReason
    {
        get { return _ChangeReason; }
        set { _ChangeReason = value; }
    }
    private string _PatientID;

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }
    private DateTime _Date;

    public DateTime Date
    {
        get { return _Date; }
        set { _Date = value; }
    }

    private string _LedgerTransactionNo;
    public string LedgerTransactionNo
    {
        get { return _LedgerTransactionNo; }
        set { _LedgerTransactionNo = value; }
    }
    private string _EnteryBy;
    public string EnteryBy
    {
        get { return _EnteryBy; }
        set { _EnteryBy = value; }
    }
    private string _Meal;
    public string Meal
    {
        get { return _Meal; }
        set { _Meal = value; }
    }
    public int isEmergency
    {
        get { return _isEmergency; }
        set { _isEmergency = value; }
    }
    public int centreID
    {
        get { return _centreID; }
        set { _centreID = value; }
    }
    public string Hospital_ID
    {
        get { return _Hospital_ID; }
        set { _Hospital_ID = value; }
    }
    public int Quantity
    {
        get { return _Quantity; }
        set { _Quantity = value; }
    }
    public string DoctorID
    {
        get { return _DoctorID; }
        set { _DoctorID = value; }
    }

    public string Route
    {
        get { return _Route; }
        set { _Route = value; }
    }


    public string prescribedItemID
    {
        get { return _prescribedItemID; }
        set { _prescribedItemID = value; }
    }



    public int IsEmergencyData
    {
        get { return _IsEmergencyData; }
        set { _IsEmergencyData = value; }
    }
    public int IsIPDData
    {
        get { return _IsIPDData; }
        set { _IsIPDData = value; }
    }
    

    public int App_ID {

        get { return _App_ID; }
        set { _App_ID = value; }
    
    }
    public string Dept { get { return _Dept; } set { _Dept = value; } }
    public int _isDischarge;
    public int isDischarge { get { return _isDischarge; } set { _isDischarge = value; } }
   
    

    public string Unit
    {
        get { return _Unit; }
        set { _Unit = value; }
    }

    public string IntervalId
    {
        get { return _IntervalId; }
        set { _IntervalId = value; }
    }

    public string IntervalName
    {
        get { return _IntervalName; }
        set { _IntervalName = value; }
    }

    public string DurationName
    {
        get { return _DurationName; }
        set { _DurationName = value; }
    }
    public string DurationVal
    {
        get { return _DurationVal; }
        set { _DurationVal = value; }
    }

    public string TimetoGive
    {
        get { return _TimetoGive; }
        set { _TimetoGive = value; }
    }

    public string RefealVal
    {
        get { return _RefealVal; }
        set { _RefealVal = value; }
    }
    public string RefealTillDate
    {
        get { return _RefealTillDate; }
        set { _RefealTillDate = value; }
    }
     
    public int DocDepartmentId
    {
        get { return _DocDepartmentId; }
        set { _DocDepartmentId = value; }
    }

    public int DocRoleId
    {
        get { return _DocRoleId; }
        set { _DocRoleId = value; }
    }
    public string DeptLedgerNo
    {
        get { return _DeptLedgerNo; }
        set { _DeptLedgerNo = value; }
    }




    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Patient_Medicine()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Patient_Medicine(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
    public virtual int PatientMedicine_ID
    {
        get
        {
            return _PatientMedicine_ID;
        }
        set
        {
            _PatientMedicine_ID = value;
        }
    }
    public virtual string TransactionID
    {
        get
        {
            return _TransactionID;
        }
        set
        {
            _TransactionID = value;
        }
    }
    public virtual string Medicine_ID
    {
        get
        {
            return _Medicine_ID;
        }
        set
        {
            _Medicine_ID = value;
        }
    }
    public virtual string NoOfDays
    {
        get
        {
            return _NoOfDays;
        }
        set
        {
            _NoOfDays = value;
        }
    }
    public virtual string NoTimesDay
    {
        get
        {
            return _NoTimesDay;
        }
        set
        {
            _NoTimesDay = value;
        }
    }
    public virtual string Dose
    {
        get
        {
            return _Dose;
        }
        set
        {
            _Dose = value;
        }
    }


    public virtual string Remarks
    {
        get
        {
            return _Remarks;
        }
        set
        {
            _Remarks = value;
        }
    }

    public virtual int Outsource
    {
        get
        {
            return _Outsource;
        }
        set
        {
            _Outsource = value;
        }
    }

    public string MedicineName
    {
        get { return _MedicineName; }
        set { _MedicineName = value; }
    }
    #endregion

    #region All Public Member Function
    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("patient_medicine");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.Medicine_ID = Util.GetString(Medicine_ID);
            this.NoOfDays = Util.GetString(NoOfDays);
            this.NoTimesDay = Util.GetString(NoTimesDay);
            this.Dose = Util.GetString(Dose);
            this.Remarks = Util.GetString(Remarks);
            this.Ischange = Util.GetInt(Ischange);
            this.ChangeReason = Util.GetString(ChangeReason);
            this.PatientID = Util.GetString(PatientID);
            this.Date = Util.GetDateTime(Date);
            this.LedgerTransactionNo = Util.GetInt(LedgerTransactionNo).ToString();
            this.Outsource = Util.GetInt(Outsource);
            this.MedicineName = Util.GetString(MedicineName);
            this.EnteryBy = Util.GetString(EnteryBy);
            this.Meal = Util.GetString(Meal);
            this.isEmergency = Util.GetInt(isEmergency);
            this.centreID = Util.GetInt(centreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Quantity = Util.GetInt(Quantity);
            this.DoctorID = Util.GetString(DoctorID);
            this.IsEmergencyData = Util.GetInt(IsEmergencyData);
            this.IsIPDData = Util.GetInt(IsIPDData);
            

            this.App_ID = Util.GetInt(App_ID);
            this.Unit = Util.GetString(Unit);
            this.IntervalId = Util.GetString(IntervalId);
            this.IntervalName = Util.GetString(IntervalName);
            this.DurationVal = Util.GetString(DurationVal);
            this.DurationName = Util.GetString(DurationName);
            this.TimetoGive = Util.GetString(TimetoGive);
            this.RefealVal = Util.GetString(RefealVal);
            this.RefealTillDate = Util.GetString(RefealTillDate);

            this.DocDepartmentId = Util.GetInt(DocDepartmentId);
            this.DocRoleId = Util.GetInt(DocRoleId);
            this.DeptLedgerNo = Util.GetString(DeptLedgerNo);




            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vMedicine_ID", Medicine_ID));
            cmd.Parameters.Add(new MySqlParameter("@vNoOfDays", NoOfDays));
            cmd.Parameters.Add(new MySqlParameter("@vNoTimesDay", NoTimesDay));
            cmd.Parameters.Add(new MySqlParameter("@vDose", Dose));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@vIsChange", Ischange));
            cmd.Parameters.Add(new MySqlParameter("@vChangeReason", ChangeReason));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Date));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@vOutsource", Outsource));
            cmd.Parameters.Add(new MySqlParameter("@vMedicineName", MedicineName));
            cmd.Parameters.Add(new MySqlParameter("@vEnteryBy", EnteryBy));
            cmd.Parameters.Add(new MySqlParameter("@vMeal", Meal));
            cmd.Parameters.Add(new MySqlParameter("@visEmergency", isEmergency));
            cmd.Parameters.Add(new MySqlParameter("@vcentreID", centreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospital_ID", Hospital_ID));
            cmd.Parameters.Add(new MySqlParameter("@vQuantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@vRoute", Route));
            cmd.Parameters.Add(new MySqlParameter("@vIsEmergencyData", IsEmergencyData));
            cmd.Parameters.Add(new MySqlParameter("@vIsIPDData", IsIPDData));            
            cmd.Parameters.Add(new MySqlParameter("@vApp_ID", App_ID)); 
            cmd.Parameters.Add(new MySqlParameter("@Unit", Unit));
            cmd.Parameters.Add(new MySqlParameter("@IntervalName", IntervalName));
            cmd.Parameters.Add(new MySqlParameter("@IntervalId", Util.GetInt(IntervalId)));
            cmd.Parameters.Add(new MySqlParameter("@DurationName", DurationName));
            cmd.Parameters.Add(new MySqlParameter("@DurationVal",Util.GetInt( DurationVal)));
            cmd.Parameters.Add(new MySqlParameter("@TimetoGive", TimetoGive));
            cmd.Parameters.Add(new MySqlParameter("@RefealVal", RefealVal));
            cmd.Parameters.Add(new MySqlParameter("@RefealTillDate",Util.GetDateTime( RefealTillDate)));
            cmd.Parameters.Add(new MySqlParameter("@DocDepartmentId", DocDepartmentId));
            cmd.Parameters.Add(new MySqlParameter("@DocRoleId", DocRoleId));
            cmd.Parameters.Add(new MySqlParameter("@DeptLedgerNo", DeptLedgerNo));
          


            iPkValue = Convert.ToInt32(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            throw (ex);
        }

    }
    #endregion
}