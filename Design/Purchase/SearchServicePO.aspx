<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchServicePO.aspx.cs" Inherits="Design_Purchase_SearchServicePO"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
      <style type="text/css">
          .selectedRow {
              background-color: aqua !important;
          }
      </style>

    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('select').chosen();
            $bindCentre(function () {
                $BindRequestType(function () {
                    $BindStoreType(function () {
                        $BindSupplier(function () {
                            
                        });
                    });
                });
            });

            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });


        var $bindCentre = function (callback) {
            serverCall('Services/ServicePO.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                $Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: 'Select' });
                callback($Centre.find('option:selected').text());
            });
        }
        var $BindRequestType = function (callback) {
            serverCall('Services/ServicePO.asmx/BindRequestType', {}, function (response) {
                $RequestType = $('#ddlRequestType');
                $RequestType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'TypeID', textField: 'TypeName', isSearchAble: true, selectedValue: 'Select' });
                callback($RequestType.find('option:selected').text());
            });
        }
        var $BindStoreType = function (callback) {
            serverCall('Services/ServicePO.asmx/BindStoreType', {}, function (response) {
                $StoreType = $('#ddlStoreType');
                $StoreType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LedgerNumber', textField: 'LedgerName', isSearchAble: true, selectedValue: 'Select' });
                callback($StoreType.find('option:selected').text());
            });
        }
        var $BindSupplier = function (callback) {
            serverCall('Services/ServicePO.asmx/BindSupplier', {}, function (response) {
                $Vendor = $('#ddlVendor');
                $Vendor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LedgerNumber', textField: 'LedgerName', isSearchAble: true, selectedValue: 'Select' });
                callback($Vendor.find('option:selected').text());
            });
        }
        function loaditem()
        {
            if ($('#chkitem').is(':checked'))
                $BindItem(function () { });
        }
        var $BindItem = function (callback) {
            serverCall('Services/ServicePO.asmx/BindItem', {}, function (response) {
                $Item = $('#ddlItem');
                $Item.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemID', textField: 'Typename', isSearchAble: true, selectedValue: 'Select' });
                callback($Item.find('option:selected').text());
            });
        }

        $showItemDetailPoupup = function (PoNumber, selectedRow,status) {
            $('#dvItemDetailPopup .modal-content').find('#spnPONumber').text(PoNumber);
          //  $('#tablePODetails tbody tr').removeClass('selectedRow');
          //  $(selectedRow).addClass('selectedRow');

            $bindPoDetails(PoNumber);
            if (status == "Rejected" || status == "Close")
                $("#btnSave,#dvRemarks").hide();
            else
                $("#btnSave,#dvRemarks").show();
        }
        $closeItemDetailPopup = function () {
            $('#dvPoItemDetails').html('');
            $('#dvItemDetailPopup').hideModel();
        }

        getPOClosedDetails = function (PoNumber) {
            $("#spnPOClosePoNumber").text('(PO Number : ' + PoNumber + ')');
            serverCall('Services/ServicePO.asmx/bindPoClosedDetails', { poNumber: PoNumber }, function (r) {
                POCloseDetails = JSON.parse(r);
                var outputPOCloseDetails = $('#tb_POCloseDetails').parseTemplate(POCloseDetails);
                $('#dvPoClosedDetails').html(outputPOCloseDetails).customFixedHeader();
                $('#dvPoClosedPopup').showModel();
            });
        }
        $closePoClosedPopup = function () {
            $('#dvPoClosedDetails').html('');
            $('#dvPoClosedPopup').hideModel();
        }

        var POClosedPrintOut = function (POCloseNumber) {
            window.open('ServicePOClosePrintOut.aspx?POCloseNumber=' + POCloseNumber);
        }

        var $bindPoDetails = function (PoNumber, callback) {
            serverCall('Services/ServicePO.asmx/bindPoDetails', { poNumber: PoNumber }, function (r) {
                PoItemDetails = JSON.parse(r);
                var outputPoItemDetails = $('#tb_POItemDetails').parseTemplate(PoItemDetails);
                $('#dvPoItemDetails').html(outputPoItemDetails).customFixedHeader();
                $('#dvItemDetailPopup').showModel();
            });
        }

        var $onQtyChange = function (rowid, callback) {;
            var closedQty = Number($(rowid).closest("tr").find("#txtClosedQty").val());
            var RejectedQty = Number($(rowid).closest("tr").find("#txtRejectedQty").val());
            var PendingQty = Number($(rowid).closest("tr").find("#tdPendingQty").text());
            // var NewPendingQty= PendingQty-RejectedQty-closedQty;

            if ($(rowid).attr('id') == "txtClosedQty")
                $(rowid).closest("tr").find("#txtRejectedQty").attr("max-value", (PendingQty - closedQty));

            if ($(rowid).attr('id') == "txtRejectedQty")
                $(rowid).closest("tr").find("#txtClosedQty").attr("max-value", (PendingQty - RejectedQty));
        }
        var $bindServicePO = function (searchType, callback) {
            $("#lblMsg").text('');
            $("#dvList").hide();

            var centreID = Number($('#ddlCentre').val());
            centreID = 1;
            if (centreID == 0) {
                $("#lblMsg").text('Please Select Centre');
                $('#ddlCentre').focus();
                return false;
            }

            data = {
                centreId: centreID,
                poNumber: $('#txtPONo').val(),
                requestType: $('#ddlRequestType').val(),
                itemId: $('#ddlItem').val(),
                vendorId: $('#ddlVendor').val(),
                status: $('#ddlStatus').val(),
                storeType: $('#ddlStoreType').val(),
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                filterType: searchType
            }

            serverCall('Services/ServicePO.asmx/bindServicePO', data, function (response) {
                PODetails = JSON.parse(response);
                if (PODetails != "") {
                    var outputPODetails = $('#tb_PODetails').parseTemplate(PODetails);
                    $('#dvPOList').html(outputPODetails).customFixedHeader();
                    MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                    $("#dvList").show();
                }
                else {
                    $("#lblMsg").text('No Record Found');
                }
            });
        }
        var ShowRequiredField = function () {
            if ($('#txtInvoiceNo').val() == "") {
                $('#txtdeliverynote').addClass("requiredField");
                $('#txtdeliverynotedate').addClass("requiredField");
                $('#txtInvoiceNo').removeClass("requiredField");
                $('#txtInvoiceDate').removeClass("requiredField");
            }
            else {
                $('#txtInvoiceNo').addClass("requiredField");
                $('#txtInvoiceDate').addClass("requiredField");
            }
        }
        var $serviceOrderClose = function (btnSave, response) {
            $("#spnMsgNew").text('');

            if ($('#txtCloseRemarks').val() == "") {
                $("#spnMsgNew").text('Please Enter Remarks');
              
                $('#txtCloseRemarks').focus();
                return false;
            }
            if ($('#txtInvoiceNo').val() == "") {
                if ($('#txtdeliverynote').val() == "") {
                    $("#spnMsgNew").text('Please Enter Deliver No.');

                    $('#txtdeliverynote').focus();
                    return false;
                }
                if ($('#txtdeliverynotedate').val() == "") {
                    $("#spnMsgNew").text('Please Enter Delivery Date');
                    $('#txtdeliverynotedate').focus();
                    return false;
                }
            }
            else {
                if ($('#txtInvoiceNo').val() == "") {
                    $("#spnMsgNew").text('Please Enter Invoice No.');

                    $('#txtInvoiceNo').focus();
                    return false;
                }
                if ($('#txtInvoiceDate').val() == "") {
                    $("#spnMsgNew").text('Please Enter Invoice Date');
                    $('#txtInvoiceDate').focus();
                    return false;
                }
            }
            debugger;
           $servicePO = [];
            $('#tablePOItemDetails tbody tr').each(function (index, row) {
                if ((Number($.trim($(row).find('#txtClosedQty').val())) + Number($.trim($(row).find('#txtRejectedQty').val()))) > 0) {
                    $servicePO.push({
                        PONumber: $.trim($('#spnPONumber').text()),
                        PODetailId: Number($.trim($(row).find('#tdPurchaseOrderDetailID').text())),
                        ItemId: $.trim($(row).find('#tdItemID').text()),
                        Amount: Number($.trim($(row).find('#tdAmount').text())) * Number($.trim($(row).find('#txtClosedQty').val    ())),
                        ClosedQty: Number($.trim($(row).find('#txtClosedQty').val())),
                        RejectedQty: Number($.trim($(row).find('#txtRejectedQty').val())),
                        InvoiceNumber: $.trim($('#txtInvoiceNo').val()),
                        InvoiceDate: $.trim($('#txtInvoiceDate').val()),
                        Remarks: $.trim($('#txtCloseRemarks').val()),
                        DeliveryNote: $.trim($('#txtdeliverynote').val()),
                        DeliveryNoteDate: $.trim($('#txtdeliverynotedate').val())
                    });
                }
            });

            if ($servicePO.length <= 0)
            {
                $("#spnMsgNew").text('Please Enter Close Qty');
                $('#tablePOItemDetails tbody tr:first').find('#txtClosedQty').focus();
                return false;
            }

            var IsMapped = 0;
            serverCall('Services/ServicePO.asmx/serviceOrderMapStatus', { servicePONumber: $servicePO[0].PONumber }, function (res) {
                var responseConfrmData = JSON.parse(res);
                modelConfirmation('Are you Sure to Close this Purchase Order ?', responseConfrmData.message, 'Yes Proceed', 'Cancel', function (status) {
                    if (status)
                    {

                        $(btnSave).attr('disabled', true).val('Submitting...');
                        serverCall('Services/ServicePO.asmx/serviceOrderClose', { servicePODetails: $servicePO, againstPO: responseConfrmData.response }, function (response) {
                            var responseData = JSON.parse(response);
                            modelAlert(responseData.response, function () {
                                if (responseData.status) {
                                    window.open('ServicePOClosePrintOut.aspx?POCloseNumber=' + responseData.message);
                                    // window.location.reload();
                                    $closeItemDetailPopup();
                                    $bindServicePO('All');
                                }
                                $(btnSave).removeAttr('disabled').val('Close Order');
                            });
                        });
                    }
                });

            });
        }

        function ChkDate() {
            data= {
                DateFrom : $('#txtFromDate').val(),
                DateTo : $('#txtToDate').val() 
            }
            serverCall('../common/CommonService.asmx/CompareDate', data, function (response) {
                var data = JSON.parse(response);
                if (data == false) {
                    DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                    $('#btnSearch').attr('disabled', 'disabled');
                }
                else {
                    $('#<%=lblMsg.ClientID %>').text('');
                    $('#btnSearch').removeAttr('disabled');
                }
            });
        }

    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Service Purchase Order Search / Close</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                          <div class="col-md-3">
                            <label class="pull-left">
                                Centre 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:DropDownList ID="ddlCentre" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Select Centre"></asp:DropDownList>
               
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPONo" runat="server" MaxLength="20" ClientIDMode="Static" TabIndex="2" ToolTip="Enter PO Number" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlRequestType" runat="server" ClientIDMode="Static" TabIndex="3" ToolTip="Select Order Type" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <input type="checkbox" id="chkitem" onchange="loaditem()" />Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:DropDownList ID="ddlItem" runat="server" ClientIDMode="Static" TabIndex="4" ToolTip="Select Item Name" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Supplier Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlVendor" runat="server" ClientIDMode="Static" TabIndex="5" ToolTip="Select Supplier" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server" ClientIDMode="Static" TabIndex="6" ToolTip="Select Status" >
                                <asp:ListItem Value="5">All</asp:ListItem>
                                <asp:ListItem Value="0">Pending</asp:ListItem>
                                <asp:ListItem Value="1">Reject</asp:ListItem>
                                <asp:ListItem Value="2">Partially</asp:ListItem>
                                <asp:ListItem Value="3">Close</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStoreType" runat="server" TabIndex="7" ToolTip="Select Store" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TabIndex="8" ToolTip="Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"> </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="9" ToolTip="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate"> </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-10"></div>
                        <div class="col-md-2">
                            <input type="button" id="btnSearch" class="ItDoseButton" value="Search" onclick="$bindServicePO('All')" tabindex="10" />
                        </div>
                        <div class="col-md-3">
                             <input type="button" id="btnReport" class="ItDoseButton" value="Report"  tabindex="11" style="display:none;" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">

                    <div class="row">
                        <div class="col-md-7"></div>
                        <%-- <div class="col-md-3">
                         <%--    <input type="button" id="btnPending" class="ItDoseButton"  title="Click for Pending Purchase Order" style="cursor: pointer;background-color:lightblue; width:25px; height:25px; border-radius:25px; "  onclick="$bindServicePO('Pending')" />
                             <b style="margin-top: 5px; margin-left: 5px;">Open</b> 
                        </div>--%>
                        <div class="col-md-3">
                             <input type="button" id="btnOpen" class="ItDoseButton"  title="Click for Open Purchase Order" style="cursor: pointer;background-color:yellow; width:25px; height:25px; border-radius:25px; "  onclick="$bindServicePO('Partially')" />
                            <b style="margin-top: 5px; margin-left: 5px;">Approved</b>
                        </div>
                        <div class="col-md-3">
                             <input type="button" id="btnClose" class="ItDoseButton"  title="Click for close Purchase Order" style="cursor: pointer;background-color:yellowgreen; width:25px; height:25px; border-radius:25px; "  onclick="$bindServicePO('Close')" />
                             <b style="margin-top: 5px; margin-left: 5px;">Close</b>
                        </div>
                        <div class="col-md-3">
                             <input type="button" id="btnRejected" class="ItDoseButton"  title="Click for rejected Purchase Order" style="cursor: pointer;background-color:LightPink; width:25px; height:25px; border-radius:25px; "  onclick="$bindServicePO('Rejected')" />
                             <b style="margin-top: 5px; margin-left: 5px;">Rejected</b>
                        </div>
                       
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvList" style="display:none;">
            <div class="Purchaseheader">
                Search Result
            </div>
             <div class="row" >
                <div class="col-md-24" style="text-align:center;">
                    <div id="dvPOList" ></div>
                </div>
            </div>
        </div>
        <div id="dvItemDetailPopup" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1100px;">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeItemDetailPopup()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">PO Number :&nbsp;<span id="spnPONumber" class="patientInfo" ></span>&nbsp;&nbsp;&nbsp;&nbsp;<span id="spnMsgNew" class="ItDoseLblError"></span></h4>
                </div>
                <div class="modal-body">
                    <div style="max-height: 300px; overflow:auto; min-height:150px;" class="row">
                        <div id="dvPoItemDetails" class="col-md-24"></div>
                    </div>
                    <div class="row" id="Div1">
                       <div class="col-md-3">
                           <label class="pull-left" >
                                Invoice Number
                            </label>
                            <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                           <asp:TextBox ID="txtInvoiceNo" runat="server" ClientIDMode="Static" onkeyup="ShowRequiredField()" ></asp:TextBox>
                          
                       </div>
                            <div class="col-md-3">
                           <label class="pull-left" >
                                Invoice Date
                            </label>
                            <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                             <asp:TextBox ID="txtInvoiceDate" ReadOnly="true"  runat="server" ClientIDMode="Static" ToolTip="Select Invoice Date"  onkeyup="ShowRequiredField()"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtInvoiceDate"> </cc1:CalendarExtender>
                         
                       </div>

                      
                     
                    </div>
                      <div class="row" id="Div2">
                            <div class="col-md-3">
                           <label class="pull-left" >
                                Delivery No.
                            </label>
                            <b class="pull-right">:</b>
                       </div>
                      <div class="col-md-5">
                           <asp:TextBox ID="txtdeliverynote" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static" class="requiredField" data-title="Enter Delivery Note"  onkeyup="ShowRequiredField()"></asp:TextBox>
                          
                       </div>
                            <div class="col-md-3">
                           <label class="pull-left" >
                                Delivert Date
                            </label>
                            <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                             <asp:TextBox ID="txtdeliverynotedate" ReadOnly="true"  class="requiredField" runat="server" ClientIDMode="Static" data-title="Enter Delivery Note"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtdeliverynotedate"> </cc1:CalendarExtender>
                         
                       </div>
                          </div>
                     <div class="row" id="dvRemarks">
                       <div class="col-md-2">
                           <label class="pull-left" >
                                Remarks
                            </label>
                            <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-22">
                          <textarea id="txtCloseRemarks" class="requiredField" autocomplete="off" ></textarea>
                       </div>
                    </div>
                </div>
                <div class="modal-footer">
                     <input type="button" id="btnSave" value="Close Order" class="save margin-top-on-btn" title="Click To Close Order" onclick="$serviceOrderClose(this);" />

                </div>
                </div>
            </div>
            </div>


       <div id="dvPoClosedPopup" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1100px;">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closePoClosedPopup()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Service PO Closed Details&nbsp;<span id="spnPOClosePoNumber" class="patientInfo" ></span></h4>
                </div>
                <div class="modal-body">
                    <div style="max-height: 300px; overflow:auto; min-height:150px;" class="row">
                        <div id="dvPoClosedDetails" class="col-md-24"></div>
                    </div>

                    <div class="row">
                          <div class="col-md-3">
                           <label class="pull-left" >
                                Invoice Number
                            </label>
                            <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                           <asp:TextBox ID="txtupdateinvoiceno" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" onkeyup="ShowRequiredField()" ></asp:TextBox>
                          
                       </div>
                            <div class="col-md-3">
                           <label class="pull-left" >
                                Invoice Date
                            </label>
                            <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                             <asp:TextBox ID="txtupdateinvoicedate" ReadOnly="true"  runat="server" ClientIDMode="Static" ToolTip="Select Invoice Date"  onkeyup="ShowRequiredField()"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtupdateinvoicedate"> </cc1:CalendarExtender>
                       </div>
                            <div class="col-md-3">
                                <input type="button" value="Update Invoice No." id="btnupdateinvoice" class="save" onclick="updateinvoiceno()" />
                            </div>
                    </div>
                </div>
                <div class="modal-footer">
                     <input type="button" id="btnClosePoPopup" value="Close" class="save margin-top-on-btn" title="Click To Popup Close" onclick="$closePoClosedPopup()" />

                </div>
                </div>
            </div>
            </div>
    </div>
    <script id="tb_PODetails" type="text/html">
        <table  id="tablePODetails" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="TrHeader">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;width: 10px;"  >S/No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">PO Number</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Supplier</th>
                      <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">PO Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Gross Amt.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Disc. Amt.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Net Amt.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Status</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">History/Update Invoice No.</th>
                </tr>
            </thead>
            <tbody>
            <#                       
                var dataLength=PODetails.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = PODetails[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" ondblclick="$showItemDetailPoupup('<#=objRow.PurchaseOrderNo#>',this,'<#=objRow.Status#>')" id="<#=j+1#>" style='cursor:pointer;background-color:<#=objRow.StatusColor#>;' >    
                    <td  class="GridViewLabItemStyle customTooltip" id="tdSRNo"style="text-align:center;width: 10px;" data-title="Double Click for Item Details or Close" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdPurchaseOrderNo" style="text-align:center;"  data-title="Double Click for Item Details or Close" ><#=objRow.PurchaseOrderNo#></td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdVendorName" style="text-align:left;"  data-title="Double Click for Item Details or Close"><#=objRow.VendorName#></td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdRaisedDate" style="text-align:center;" data-title="Double Click for Item Details or Close" ><#=objRow.RaisedDate#></td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdGrossTotal" style="text-align:center;" data-title="Double Click for Item Details or Close" ><#=objRow.GrossTotal#></td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdDiscount" style="text-align:center;" data-title="Double Click for Item Details or Close" ><#=objRow.Discount#></td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdNetTotal" style="text-align:center;" data-title="Double Click for Item Details or Close" ><#=objRow.NetTotal#></td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdStatus" style="text-align:center;" data-title="Double Click for Item Details or Close" ><#=objRow.Status#></td>
                   <td style="text-align:center;" class="GridViewLabItemStyle">
                     <img alt="" src="../../Images/view.GIF" class="imgPlus"  style="cursor:pointer" onclick="getPOClosedDetails('<#=objRow.PurchaseOrderNo#>')"  />
                    </td>                      
                </tr>          
            <#}#>
            </tbody>      
        </table>
         </script>
    
     <script id="tb_POItemDetails" type="text/html">
        <table  id="tablePOItemDetails" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="TrItemHeader">
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;width: 25px;"  >S/No. </th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:left;">Item Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Order Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Approved Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Pre Closed Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;display:none;">Pre Rejected Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Pending Qty</th>
                     <th class="GridViewHeaderStyle" scope="col" style="text-align:center;display:none">Invoice Number</th>
                     <th class="GridViewHeaderStyle" scope="col" style="text-align:center;display:none">Invoice Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Closed Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;display:none;">Rejected Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">ItemId</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">PRDetailId</th>
                     <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">Amount</th>
                </tr>
            </thead>
            <tbody>
            <#           
                var dataLength=PoItemDetails.length;
                for(var k=0;k<dataLength;k++)
                {           
                    var objRow = PoItemDetails[k];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color='' " style="cursor:pointer;" id='<#=objRow.PurchaseOrderDetailID#>' >                                                            
                    <td  class="GridViewLabItemStyle" id="tdSerialNo" style="text-align:center;width: 25px;" ><#=k+1#></td>
                    <td class="GridViewLabItemStyle" id="tdItemName" style="text-align:left;" ><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="tdOrderedQty" style="text-align:center;" ><#=objRow.OrderedQty#></td>
                    <td class="GridViewLabItemStyle" id="tdApprovedQty" style="text-align:center;" ><#=objRow.ApprovedQty#></td>
                    <td class="GridViewLabItemStyle" id="tdPreClosedQty" style="text-align:center;display:none;" ><#=objRow.RecievedQty#></td>  
                    <td class="GridViewLabItemStyle" id="tdPreRejectedQty" style="text-align:center;" ><#=objRow.RejectQty#></td>
                    <td class="GridViewLabItemStyle" id="tdPendingQty" style="text-align:center;" ><#=objRow.PendingQty#></td>   
                    <td class="GridViewLabItemStyle" id="td1" style="text-align:center;display:none" ><#=objRow.InvoiceNumber#></td>
                    <td class="GridViewLabItemStyle" id="td2" style="text-align:center;display:none" ><#=objRow.InvoiceDate#></td> 
                    <td class="GridViewLabItemStyle" id="tdClosedQty" style="text-align:center; width:100px;" >
                        <input id="txtClosedQty" onlynumber="10" decimalplace="3" max-value='<#=objRow.PendingQty#>' onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$onQtyChange(this);" class="ItDoseTextinputNum" type="text" title="Enter Closed Qty"
                             <#if(objRow.PendingQty=="0"){#> disabled <#} #> /> 
                    </td>
                    <td class="GridViewLabItemStyle" id="tdRejectedQty" style="text-align:center; width:100px;display:none;" >
                        <input id="txtRejectedQty" onlynumber="10" decimalplace="3" max-value='<#=objRow.PendingQty#>' onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$onQtyChange(this);" class="ItDoseTextinputNum" type="text" title="Enter Rejected Qty" 
                             <#if(objRow.PendingQty=="0"){#> disabled <#} #> /> 
                    </td>
                    <td class="GridViewLabItemStyle" id="tdItemID" style="text-align:center; display:none;" ><#=objRow.ItemID#></td>   
                    <td class="GridViewLabItemStyle" id="tdPurchaseOrderDetailID" style="text-align:center; display:none;" ><#=objRow.PurchaseOrderDetailID#></td>  
                    <td class="GridViewLabItemStyle" id="tdAmount" style="text-align:center; display:none;" ><#=objRow.Amount#></td>  
                                
                </tr>       
            <#}#>
          </tbody>      
        </table>
      </script>

     <script id="tb_POCloseDetails" type="text/html">
        <table  id="tablePOCloseDetails" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="TrPOCHeader">
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;width: 25px;"  >S/No. </th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">PO Close Number</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Remarks</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Entry By</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Invoice No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Select</th>
                </tr>
            </thead>
            <tbody>
                <#           
                    var dataLength=POCloseDetails.length;
                    for(var k=0;k<dataLength;k++)
                    {           
                        var objRow = POCloseDetails[k];
                #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color='' " ondblclick="POClosedPrintOut('<#=objRow.POCloseNumber#>')" style="cursor:pointer;" id='Tr2' >                                                            
                    <td  class="GridViewLabItemStyle" style="text-align:center;width: 25px;" ><#=k+1#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.POCloseNumber#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.EntryDateTime#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.Amount#></td>
                    <td class="GridViewLabItemStyle" style="text-align:left;" ><#=objRow.Remarks#></td>   
                    <td class="GridViewLabItemStyle"  style="text-align:center;" ><#=objRow.EmployeeName#></td>   
                    <td class="GridViewLabItemStyle"  style="text-align:center;display:none" id="txtsepvicepoid" ><#=objRow.id#></td>
                    <td class="GridViewLabItemStyle"  style="text-align:center;" id="Td3" ><#=objRow.InvoiceNumber#></td>   
                      <#if(objRow.InvoiceNumber ==""){#> 
                    <td class="GridViewLabItemStyle"  style="text-align:center;" ><input type="checkbox" id="chkinvoiceno" /></td>    
                      <#}else{#>
                    <td class="GridViewLabItemStyle"  style="text-align:center;" ></td>    
                     <#}#>        
                </tr>       
            <#}#>
          </tbody>      
        </table>
      </script>
    
    <script type="text/javascript">
        var updateinvoiceno = function () {
            var $updateservicePO = [];
            $('#tablePOCloseDetails tbody tr').each(function (index, row) {
                if ($(row).find('#chkinvoiceno').is(':checked')) {
                    $updateservicePO.push({
                        id: $(row).find('#txtsepvicepoid').text(),
                        invoiceno: $('#txtupdateinvoiceno').val(),
                        invoicedate: $('#txtupdateinvoicedate').val()
                    });
                }
            });
            if ($updateservicePO.length <= 0) {
                modelAlert('Please Select The Service PO.');
                return false;
            }
            if ($('#txtupdateinvoiceno').val() == "")
            {
                modelAlert('Please Enter The Invoice No.');
                return false;
            }
            if ($('#txtupdateinvoicedate').val() == "")
            {
                modelAlert('Please Enter The Invoice Date');
                return false;
            }
            $('#btnupdateinvoice').attr('disabled', true).val('Update Invoice No....');
            serverCall('Services/ServicePO.asmx/updateinvoiceno', { updateinvoicedata: $updateservicePO }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        $('#txtupdateinvoiceno,#txtupdateinvoicedate').val('');
                        $closePoClosedPopup()
                        $bindServicePO('All');
                    }
                    $('#btnupdateinvoice').removeAttr('disabled').val('Update Invoice No.');
                });
            });
        };
    </script>
</asp:Content>
