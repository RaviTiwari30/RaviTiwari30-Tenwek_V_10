<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EMG_DoctorVisit.aspx.cs" Inherits="Design_Emergency_EMG_DoctorVisit" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
      <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

      <script type="text/javascript">
          var EmergencyPatientDetails = [];
          var EmergencyVisitDetails = [];
          var UserRights = [];
          $(document).ready(function () {
              $bindDoctor(function () {
                  $bindVisitType(function () {
                      $bindUserRights(function () {
                          $EMGNo = "<%=Request.QueryString["EMGNo"].ToString()%>";
                        serverCall('../Emergency/Services/EmergencyBilling.asmx/getEmergencyPatientDetails', { EmergencyNo: $EMGNo }, function (response) {
                            debugger;
                            if (jQuery.parseJSON(response) == null)
                                location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Shifted To IPD.'
                            else {
                                EmergencyPatientDetails = jQuery.parseJSON(response)[0];
                                if (UserRights.CanEditCloseEMGBilling == "0") {
                                    if (EmergencyPatientDetails.Status == 'OUT')
                                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released.'
                                    else if (EmergencyPatientDetails.BillNo != '')
                                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Bill Has Been Generated.'
                                    else if (EmergencyPatientDetails.Status == "RFI")
                                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released for IPD.';
                                    else
                                        $('#ddlDoctor').chosen('destroy').val(EmergencyPatientDetails.DoctorID).chosen().change();
                                }
                            }
                        });
                    });
                });
            });
            $('#ddlDoctor,#ddlVisitType').change(function () {
                var data = { DoctorID: $('#ddlDoctor').val(), referenceCodeOPD: EmergencyPatientDetails.ReferenceCodeOPD, SubCategoryID: $('#ddlVisitType').val(), panelCurrencyFactor: 1 };
                serverCall('../common/CommonService.asmx/Loadrate', data, function (response) {
                    EmergencyVisitDetails = jQuery.parseJSON(response)[0];
                    if (EmergencyVisitDetails != '' && EmergencyVisitDetails != undefined)
                        $('#lblCharges').text(EmergencyVisitDetails.Rate);
                    else
                        $('#lblCharges').text('0');
                });

            });


        });

        var $bindDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: 'All' }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }
        var $bindVisitType = function (callback) {
            serverCall('../common/CommonService.asmx/bindAppVisitType', {}, function (response) {
                $ddlAppointmentType = $('#ddlVisitType');
                $ddlAppointmentType.bindDropDown({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });
                $EMGVisitId = '<%=Resources.Resource.EmergencyVisitSubCategoryId.ToString()%>'
                if (!String.isNullOrEmpty($EMGVisitId))
                    $ddlAppointmentType.chosen('destroy').val($EMGVisitId).chosen();
                callback($ddlAppointmentType.val());
            });
        }
        $bindUserRights = function (callback) {

            serverCall('Services/EmergencyBilling.asmx/getEmergencyUserRights', {}, function (response) {
                UserRights = jQuery.parseJSON(response)[0];
                if (UserRights.CanViewRatesEMGBilling == 0)
                    $('.RateElement').hide();
                callback(true);
            });


        }
    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
              <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Emergency Doctor Visit</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Doctor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="requiredField" ClientIDMode="Static"
                                     TabIndex="1" ToolTip="Select Doctor" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Visit Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                               <asp:DropDownList ID="ddlVisitType" runat="server" ClientIDMode="Static" CssClass="requiredField" TabIndex="2"></asp:DropDownList>
                            </div>
                             <div class="col-md-3">
                                <label class="pull-left">
                                  Visit Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                               <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static"
                                  ReadOnly="true"></asp:TextBox>
                                 <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            </div>
                             <div class="col-md-3 RateElement">
                                <label class="pull-left">
                                    Charges
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 RateElement">
                                <label id="lblCharges" style="color:#d01515;font-weight:bold;">0</label>
                             </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align:center;">
                    <input type="button" value="Save" style="width:100px;margin-top:7px;" onclick="$save()" />
                    </div>
                </div>
        </div>

    </form>
    <script>
        $save = function () {
            if ($('#ddlDoctor').val() == '0') {
                modelAlert('Please Select Doctor', function () {
                    $('#ddlDoctor').focus();
                    
                });
                return false;
            }
            if (EmergencyVisitDetails.Rate == 0)
            {
                modelAlert('Doctor Fees is not set.', function () {
                });
                return false;
            }
            $LTD = {
                LedgerTransactionNo:EmergencyPatientDetails.LTnxNo,
                TransactionID:EmergencyPatientDetails.TID,
                ItemID:EmergencyVisitDetails.ItemID,
                SubCategoryID:EmergencyVisitDetails.SubCategoryID,
                ItemName:EmergencyVisitDetails.Item,
                RateListID: EmergencyVisitDetails.ID,
                rateItemCode: EmergencyVisitDetails.ItemCode,
                Rate: EmergencyVisitDetails.Rate,
                Amount: EmergencyVisitDetails.Rate,
                DoctorID: $('#ddlDoctor').val(),
                IPDCaseType_ID:EmergencyPatientDetails.IPDCaseType_ID,
                Room_ID: EmergencyPatientDetails.Room_Id,
                EntryDate: $('#txtDate').val(),
            }
            serverCall('../Emergency/Services/EmergencyBilling.asmx/SaveEmergencyVisit', { LTD: [$LTD] }, function (response) {
                var $responseData = JSON.parse(response);
                if($responseData.status)
                modelAlert($responseData.response, function () {
                        location.reload();

                    });
                else
                modelAlert($responseData.response);
            });

        }
    </script>
</body>
</html>
