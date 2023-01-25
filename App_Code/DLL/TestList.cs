using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// Summary description for TestList
/// </summary>
public class TestList
{
    private string _PatientID;

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }
    private string _PatientName;

    public string PatientName
    {
        get { return _PatientName; }
        set { _PatientName = value; }
    }


    private string _Age;
    public string Age
    {
        get { return _Age; }
        set { _Age = value; }
    }


    private DateTime _DOB;
    public DateTime DOB
    {
        get { return _DOB; }
        set { _DOB = value; }
    }

    private string _SEX;
    public string SEX
    {
        get { return _SEX; }
        set { _SEX = value; }
    }

    private string _ReferingPhysicianName;
    public string ReferingPhysicianName
    {
        get { return _ReferingPhysicianName; }
        set { _ReferingPhysicianName = value; }
    }


    private string _AccessionNumber;
    public string AccessionNumber
    {
        get { return _AccessionNumber; }
        set { _AccessionNumber = value; }
    }

    private string _ModalityName;
    public string ModalityName
    {
        get { return _ModalityName; }
        set { _ModalityName = value; }
    }

    private string _ReqProcedureDescription;
    public string ReqProcedureDescription
    {
        get { return _ReqProcedureDescription; }
        set { _ReqProcedureDescription = value; }
    }

    private DateTime _SchProcStepStartDate;
    public DateTime SchProcStepStartDate
    {
        get { return _SchProcStepStartDate; }
        set { _SchProcStepStartDate = value; }
    }


    private string _StudyInstanceUId;
    public string StudyInstanceUId
    {
        get { return _StudyInstanceUId; }
        set { _StudyInstanceUId = value; }
    }


}