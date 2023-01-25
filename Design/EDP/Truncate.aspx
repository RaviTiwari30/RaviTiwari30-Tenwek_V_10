<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Truncate.aspx.cs" Inherits="Design_Truncate" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script src="../../Scripts/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">


        $(document).ready(function () {
            //Validate User (only localhost running site can truncate data)
            if (document.location.hostname != 'localhost') {
                $('#btnTruncate').hide();
                $('#btnClient').hide();
                $("#lblError").text("You Are Not Authorize To Truncate Tables!");
            }
            $('#btnTruncate').click(function () {
                $('#lblError').text('');
                $('#btnTruncate').val('submitting....').attr('disabled', 'disabled');
                var con = 0;
                var Ok = confirm('Are you sure you want to truncate client table?');
                if (Ok)  
                    con = 0;
                else
                    con = 1;
                if (con == "0") {
                  
                    $("#lblError").text("Please Wait...................");
                    $.blockUI({ message: "<h3>Please wait...</h3>" });

                    $.ajax({
                        type: "POST",
                        url: "Services/EDP.asmx/truncateTransaction",
                        data: '{}',
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        async: false,
                        success: function (response) {
                            data = (response.d);
                            if (data == "1")
                                $("#lblError").text('Transaction Table Truncated Successfully');
                            else
                                DisplayMsg('MM05', 'lblError');
                        },
                        complete: function () {
                            $.unblockUI();
                            $('#btnTruncate').val('Truncate Transaction Tables').removeAttr('disabled');
                        },
                        error: function (xhr, status) {
                            $('#btnTruncate').val('Truncate Transaction Tables').removeAttr('disabled');
                            DisplayMsg('MM05', 'lblError');
                            window.status = status + "\r\n" + xhr.responseText;
                            $.unblockUI();
                        }
                    });
                }
                else {
                    $('#btnTruncate').val('Truncate Transaction Tables').removeAttr('disabled');
                }
            });
        });
        function truncateClient() {
            $('#lblError').text('');
            $('#btnClient').val('submitting....').attr('disabled', 'disabled');
            var con = 0;
            var Ok = confirm('Are you sure, you want to truncate Master Tables?');
            if (Ok)
                con = 0;
            else
                con = 1;
            if (con == "0") {
                
                $("#lblError").text("Please Wait...................");
                $.blockUI({ message: "<h3>Please wait...</h3>" });
                $.ajax({
                    type: "POST",
                    url: "Services/EDP.asmx/truncateClientTransaction",
                    data: '{}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        data = (response.d);
                        if (data == "1")
                            $("#lblError").text('Master Tables Truncated Successfully');
                        else
                            DisplayMsg('MM05', 'lblError');
                    },
                    complete: function () {
                        $.unblockUI();
                        $('#btnClient').val('Truncate Master Tables').removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        $('#btnClient').val('Truncate Master Tables').removeAttr('disabled');
                        DisplayMsg('MM05', 'lblError');
                        window.status = status + "\r\n" + xhr.responseText;
                        $.unblockUI();
                    }


                });
            }
            else {
                $('#btnClient').val('Truncate Master Tables').removeAttr('disabled');
            }
        }
        function View() {

        }



    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Truncate Table Master</b><br />
            <span id="lblError" class="ItDoseLblError"></span>

        </div>
        <div class="POuter_Box_Inventory">
            <br />
            <table style="width: 100%">
                <tr style="text-align: center">
                    <td  style="width:50%">
                        <input type="button" value="Truncate Transaction Tables" id="btnTruncate" class="ItDoseButton" />

                    </td>
                    <td style="width:50%">
                        <input type="button" value="Truncate Master Tables" id="btnClient" onclick="truncateClient()" class="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
        <div id="question" style="display: none; cursor: default; width: 540px; text-align: center">
            <h1>Are you sure you want to truncate transaction table?</h1>
            <input type="button" id="yes" value="Yes" />
            <input type="button" id="no" value="No" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left">
            <b>Hospital Master</b>
            <br />
            <em><span style="font-size: 9.5pt; color: #0000ff;">&nbsp;&nbsp;&nbsp;&nbsp;1. Set IsBasecurrency from
                 <a href="CountryMaster.aspx" target="_blank">Country Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;2. Set Currency and Converson Factor from 
                <a href="CurrencyFactor_Master.aspx" target="_blank">Converson Factor Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;3. Set Hospital General Detail from 
                <a href="HospitalMaster.aspx" target="_blank">Hospital Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;4. Create Panel from                     
            <a href="PanelMaster.aspx" target="_blank">Panel Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;5. Create New Schedule Charges from  
             <a href="Rate_scheduleCharges.aspx" target="_blank">Schedule Charge Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;6. Create Receipt Header from 
             <a href="ReceiptHeader.aspx" target="_blank">Receipt Header Master</a>
                <br />
               
                &nbsp;&nbsp;&nbsp;&nbsp;7. Discount Approval from 
             <a href="ApprovalTypeMaster.aspx" target="_blank">Discount Approval Master</a>
                <br />
            </span></em>
            <br />
            <b>OPD Master</b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;1. Create Doctor Type from
                <a href="../Doctor/DocGroup.aspx" target="_blank">Doctor Type Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;2. Create Doctor Visit Type from (Create under "OPD Consultation")
                <a href="SubCategoryMaster.aspx" target="_blank">SubCategory Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;3. Create Doctor and OPD Appointment Slot from (Create first Dr. as "Self")
                <a href="../Doctor/DoctorReg.aspx" target="_blank">Doctor Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;4. Set Doctor OPD Rates from
                <a href="../Doctor/ViewDoctorDetail.aspx" target="_blank">Doctor Rate Master</a>
                <br />

                &nbsp;&nbsp;&nbsp;&nbsp;5. Create Department  
                <a href="../Lab/ObservationType.aspx" target="_blank">Department Master</a>
                <br />

                &nbsp;&nbsp;&nbsp;&nbsp;6. Bind Investigation Group with Department  
                <a href="CategoryLabRole.aspx" target="_blank">Bind Investigation Group with Department</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;7. Create Investigation from (Laboratory OR Radiology Login)  
               <%--<a href="../Lab/MapInvestigationObservationNew.aspx" target="_blank">Investigation Master</a>  --%>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;8. Create OPD Package from
                <a href="ManagePackage.aspx" target="_blank">OPD Package Master</a>
                <br />
                 &nbsp;&nbsp;&nbsp;&nbsp;9. Create Department for Procedure    
                <a href="SubCategoryMaster.aspx" target="_blank">SubCategoryMaster Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;10. Create Procedure and Other Items from   
                <a href="ItemMaster.aspx" target="_blank">Item Master</a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;11. Set Investigation, Procedure and Other Item Rates from
                <a href="RateList.aspx" target="_blank">Rate List</a>
                <br />
                <%-- Note: Create Three Items from the Item Master Under Other Charges Category: a)Medication Fee b)Registration Charges c) Other Charges/Fee
                        (Change their Id in the Global resource File thereby)
                --%>
            </span>
            </em>
            <br />
             <b>Laboratory </b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;1. Create Observation and Map with Investigation from 
               (Laboratory Login) 

              
                <br />
                 &nbsp;&nbsp;&nbsp;&nbsp;2. Manage Approval Master from
                (Laboratory Login)
               <br />
 </span>
            </em>
            <br />
             <b>Radiology </b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                 &nbsp;&nbsp;&nbsp;&nbsp;1. Manage Approval Master from
                (Radiology Login)
               <br />
 </span>
            </em>
            <br />
            
            <b>Store and Purchase</b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;1. Create Category for Medical/General Items(if not Exists.) from 
                <a href="CategoryMaster.aspx" target="_blank">Category Master
                </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;2. Create SubCategory for Medical/General Items(if not Exists.) from
                <a href="SubCategoryMaster.aspx" target="_blank">SubCategory Master
                </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;3. Create Items from
                <a href="../Store/ItemMaster.aspx" target="_blank">Item Master
                </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;4. Create Supplier from
                <a href="../Store/VendorDetail.aspx" target="_blank">Supplier Master
                </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;5. Create Manufacture from
                <a href="../Store/ManufactureMaster.aspx" target="_blank">Manufacture Master
                </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;6. Manage Approval
                <a href="../Purchase/ManageApproval.aspx" target="_blank">Manage Approval Master
                </a>

            </span>
            </em>
            <br />
            <br />
            <b>IPD </b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;1. Room Master
                <a href="AddRoom.aspx" target="_blank">Room Master
                </a>
                <br />
            &nbsp;&nbsp;&nbsp;&nbsp;2. Create Doctor Visit Type from (Create under &quot;IPD Consultation Visit&quot;)
                 <a href="SubCategoryMaster.aspx" target="_blank">SubCategory Master</a>
            <br />
                
            &nbsp;&nbsp;&nbsp;&nbsp;3. Set Doctor Rate From 
                 <a href="../Doctor/DocGroupRateMaster.aspx" target="_blank">Doctor Group Rate Master</a>
           OR <a href="../Doctor/ViewDoctorDetail.aspx" target="_blank">Doctor Edit </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;4. Surgery Type (Surgery Bifurcation)
                <a href="NewSurgeryType.aspx" target="_blank">Surgery Type
                </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;5. Surgery Master
                <a href="SurgeryMaster.aspx" target="_blank">Surgery Master
                </a>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;6. User Rights
                <a href="UserAuthorization.aspx" target="_blank">User Rights Master
                </a>
                 <br />
                &nbsp;&nbsp;&nbsp;&nbsp;7. Set Room, Investigation, Procedure, Surgery and Other Item Rates from
                <a href="RateList.aspx" target="_blank">Rate List</a>
               
            </span>
            </em>
            <br />
            <br />

            <b>Discharge Summary</b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;1. Header Master
                <a href="../EMR/HeaderMaster.aspx" target="_blank">Header Master
                </a>
            </span>
            </em>
             <br />
            <br />

            <b>Ward</b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;1. Bind RoomType with Department from
                <a href="RoomType_Role.aspx" target="_blank">Bind RoomType with Department

                </a>
            </span>
            </em>
            <br />
            <br />
             <b>Doctor Accounting</b>
            <em><span style="font-size: 9.5pt; color: #0000ff;">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;1. Set Doctor Share Date from
                <a href="../DocAccount/SetDocShareDate.aspx" target="_blank">Set Doctor Share Date

                </a>
            </span>
            </em>
            <br />
            <br />
        </div>

    </div>
</asp:Content>
