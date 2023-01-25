<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UnallocatedTransfer.aspx.cs" Inherits="Design_Dispatch_UnallocatedTransfer" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="sc" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Un-Allocated Amount Transfer Screen</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">From Panel Detail</div>
            <div class="col-md-24">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Centre</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlCentre" onchange="$bindPanel()" runat="server" ClientIDMode="Static"></asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">From Panel</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlFromPanel" onchange="$GetVoucher(this)"></select>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlVoucherdetailsfrom" onchange="$GetAmount(this)"></select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Total Amount</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <span id="spntotalamount" style="color: red; font-weight: bold">0</span>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Remaining Amount</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <span id="spnremainingamount" style="color: red; font-weight: bold">0</span>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">To Panel Detail</div>
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlType" onchange="onTypeChnage(this)">
                                <option value="0">Transfer Amount</option>
                                <option value="1">Reversal Amount</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">To Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlToPanel" ></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"><span id="spnType">Transfer Amount</span></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtTransferAmount" data-title="Transfer Amount" class="ItDoseTextinputNum" onkeyup="onDataChange(this)" onlynumber="14" decimalplace="2" max-value="10000000" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align: center">
                    <input type="button" value="Save" onclick="$TransferAmount()" />
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $bindPanel(function (p) {
                $('#txtTransferAmount').attr('max-value', Number($('#spnremainingamount').text()));
            });
        });


        //var $bindPanel = function (callback) {
        //      serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
        //          var $ddlFromPanel = $('#ddlFromPanel');
        //          var $ddlToPanel = $('#ddlToPanel');
        //          $ddlFromPanel.bindDropDown({defaultValue: 'Select', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
        //          $ddlToPanel.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
        //          callback(true);
        //      });
        //}

        var $bindPanel = function (element) {
            //   var centreId = $('#ddlCentre').val();
            serverCall('UnallocatedTransfer.aspx/bindPanel', { centreId: $('#ddlCentre').val() }, function (response) {
                var result = JSON.parse(response);
                $('#ddlFromPanel').bindDropDown({ defaultValue: 'Select', data: result.message, valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
                $('#ddlToPanel').bindDropDown({ defaultValue: 'Select', data: result.message, valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
            });

        }

        var $GetVoucher = function (element) {
            $Clear(function (p) {
                $('#ddlToPanel').chosen('destroy').val(0).chosen();
                var centreId = $('#ddlCentre').val();
                serverCall('UnallocatedTransfer.aspx/GetPanelAccountVoucher', { panelID: element.value, centreId: centreId }, function (response) {
                    var result = JSON.parse(response);
                    $('#ddlVoucherdetailsfrom').bindDropDown({ defaultValue: 'Select', data: result.message, valueField: 'ID', textField: 'Text', isSearchAble: true });
                });
            });
        }
        var $GetAmount = function (ele) {
            $Clear(function (p) {
                $('#ddlToPanel').chosen('destroy').val(0).chosen();
                $('#spntotalamount').text($('#ddlVoucherdetailsfrom').val().split('#')[1]);
                $('#spnremainingamount').text($('#ddlVoucherdetailsfrom').val().split('#')[2]);
                $('#txtTransferAmount').attr('max-value', $('#ddlVoucherdetailsfrom').val().split('#')[2]);
            });
        }

        var onTypeChnage = function (el) {
           if (Number($(el).val()) == 1)
           {
               $('#ddlToPanel').val("0").attr('disabled', true).chosen("destroy").chosen();
               $("#spnType").text("Reversal Amount");
           }
           else
           {
               $("#ddlToPanel").attr("disabled", false).chosen("destroy").chosen();;
               $("#spnType").text("Transfer Amount");
           }
         
        }
        var $TransferAmount = function () {
            if ($('#ddlToPanel').val() == $('#ddlFromPanel').val()) {
                modelAlert('Can not Transfer The Amount Within The Panel.', function () { $('#ddlToPanel').focus() });
                return;
            }
            if ($('#ddlVoucherdetailsfrom').val() == 0) {
                modelAlert('Please Select Voucher.', function () { $('#ddlVoucherdetailsfrom').focus() });
                return;
            }
            if ($('#ddlToPanel').val() == "0" && Number($('#ddlType').val()) == 0) {
                modelAlert('Please Select To Panel.', function () { $('#ddlToPanel').focus() });
                return;
            }
            if ($('#txtTransferAmount').val() <= 0) {
                modelAlert("Invalid Amount.");
                return;
            }
 
            var messageContent = "To " + $("#ddlType option:selected").text() + " ? ";
            modelConfirmation('Are You Sure ?', messageContent, 'Yes', 'No', function (res) {
                if (res) {

                    var data = {
                        ID: $('#ddlVoucherdetailsfrom').val().split('#')[0],
                        ToPanel: Number($('#ddlType').val())==0 ? $('#ddlToPanel').val() :"0",
                        Amount: $('#txtTransferAmount').val(),
                        CentreID: $('#ddlCentre').val(),
                        type: Number($('#ddlType').val())
                    }
                    serverCall('UnallocatedTransfer.aspx/TransferAmount', data, function (response) {
                        var result = JSON.parse(response);
                        if (result.status) {
                            window.location.reload();
                        }
                        else
                            modelAlert(result.message);
                    });
                }
            });
        }

        $Clear = function (callback) {
            $('#spntotalamount').text(0);
            $('#spnremainingamount').text(0);
            $('#txtTransferAmount').val(0);
            $('#txtTransferAmount').attr('max-value', Number($('#spnremainingamount').text()));
            callback(true);
        }
    </script>
</asp:Content>

