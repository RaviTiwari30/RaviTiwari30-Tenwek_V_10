<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" MasterPageFile="~/DefaultHome.master"
    CodeFile="DirectGRN_Asset.aspx.cs" Inherits="Design_Store_DirectGRN_Asset" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

    <script type="text/javascript">

        $(document).ready(function () {
            $('#<%=txtChallanNo.ClientID %>,#<%=txtBillDate.ClientID %>,#<%=txtChallanDate.ClientID %>,#<%=txtWayBillDate.ClientID%>').attr('disabled', true);
            
            $('#ddlGRNType').change(function () {
                if ($('#ddlGRNType').val() == "0") {
                    $('#<%=txtChallanNo.ClientID%>,#<%=txtChallanDate.ClientID%>').val('').attr('disabled', true);
                    
                }
                if ($('#ddlGRNType').find(':checked').val() == "1") {
                    $('#<%=txtBillNo.ClientID%>,#<%=txtBillDate.ClientID%>').val('').attr('disabled', true);
                }
                if ($('#ddlGRNType').find(':checked').val() == "3") {
                    $('#<%=txtChallanNo.ClientID%>,#<%=txtChallanDate.ClientID%>,#<%=txtBillNo.ClientID%>,#<%=txtBillDate.ClientID%>').val('').attr('disabled', true);
                }
                checkGRNType();
            });
        });
        function CheckBillDate() {
            if ($('#<%=txtBillNo.ClientID %>').val() != "") {
                $('#<%=txtBillDate.ClientID %>').removeAttr('disabled');
            }
            else {
                $('#<%=txtBillDate.ClientID %>').attr('disabled', true);
            }
            if ($('#<%=txtChallanNo.ClientID %>').val() != "") {
                $('#<%=txtChallanDate.ClientID %>').removeAttr('disabled');
            }
            else {
                $('#<%=txtChallanDate.ClientID %>').attr('disabled', true);
            }
            if ($('#<%=txtWayBillNo.ClientID%>').val() !== "") {
                $('#<%=txtWayBillDate.ClientID%>').removeAttr('disabled');
            }
            else {

                $('#<%=txtWayBillDate.ClientID%>').attr('disabled', true);
            }
        }

        function checkGRNType() {
            if ($('#ddlGRNType').val() == "0") {
                $('#<%=txtBillNo.ClientID %>').removeAttr('disabled');
            }
            if ($('#ddlGRNType').find(':checked').val() == "1") {
                $('#<%=txtChallanNo.ClientID %>').removeAttr('disabled');
            }
            if ($('#ddlGRNType').find(':checked').val() == "3") {
                $('#<%=txtBillNo.ClientID %>,#<%=txtChallanNo.ClientID %>').removeAttr('disabled');
            }
        }
    </script>
    <script type="text/javascript">
<!--
    function wopen(url, name, w, h) {
        // Fudge factors for window decoration space.
        // In my tests these work well on all platforms & browsers.
        w += 32;
        h += 96;
        var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
        win.resizeTo(w, h);
        win.moveTo(10, 100);
        win.focus();
    }
    // -->
    </script>
    <script type="text/javascript">
        function LTrim(value) {
            var re = /\s*((\S+\s*)*)/;
            return value.replace(re, "$1");
        }
        function RTrim(value) {
            var re = /((\s*\S+)*)\s*/;
            return value.replace(re, "$1");
        }

        // Removes leading and ending whitespaces
        function trim(value) {
            return LTrim(RTrim(value));
        }
        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtNarration.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtNarration.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });

        //$(function () {
        //    $("#datepicker").datepicker();
        //});

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Asset Direct GRN</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <asp:Panel ID="pnlPurchase" runat="server" Width="100%">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Order Detail
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Supplier
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlVendor" CssClass="requiredField" runat="server" TabIndex="2" ClientIDMode="Static">
                                </asp:DropDownList>
                                <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" Style="display: none;" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="True" TabIndex="1" ClientIDMode="Static">
                                    <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                                    <asp:ListItem Value="STO00002" Selected="True">General Store</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Purchase Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtPurDate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                                </asp:TextBox>
                                <cc1:CalendarExtender ID="calPurDate" TargetControlID="txtPurDate" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-2">
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    WayBill No. & Date 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtWayBillNo" runat="server" onkeyup="CheckBillDate()" CssClass="requiredField" MaxLength="50" Width="58%" TabIndex="4" ClientIDMode="Static">
                                </asp:TextBox>
                                <asp:TextBox ID="txtWayBillDate" CssClass="requiredField" runat="server" Width="40%" TabIndex="5" ClientIDMode="Static">
                                </asp:TextBox>
                                <cc1:CalendarExtender ID="calWayBillDate" TargetControlID="txtWayBillDate" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">GRN Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlGRNType" runat="server" ClientIDMode="Static" TabIndex="6">
                                    <asp:ListItem Text="Invoice" Value="0" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Challan" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Challan with Invoice" Value="3"></asp:ListItem>
                                </asp:DropDownList>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Invoice No.& Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBillNo" CssClass="requiredField" runat="server" onkeyup="CheckBillDate()" MaxLength="50" Width="58%" TabIndex="7" ClientIDMode="Static"> </asp:TextBox>
                                <asp:TextBox ID="txtBillDate" CssClass="requiredField" runat="server" Width="40%" TabIndex="8" ClientIDMode="Static"> </asp:TextBox>
                                <cc1:CalendarExtender ID="calBillDate" TargetControlID="txtBillDate" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Challan No. & Date 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtChallanNo" runat="server" onkeyup="CheckBillDate()" CssClass="requiredField" MaxLength="50" Width="58%" ClientIDMode="Static" TabIndex="9">
                                </asp:TextBox>
                                <asp:TextBox ID="txtChallanDate" CssClass="requiredField" runat="server" Width="40%" ClientIDMode="Static" TabIndex="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalchallanDate" TargetControlID="txtChallanDate" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Gate Entry No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtGatePassInWard" runat="server" TabIndex="11" ClientIDMode="Static">
                                </asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    GRN Pay. Mode
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdoGRNPayType" runat="server"
                                    RepeatColumns="2" RepeatDirection="Horizontal" TabIndex="12" ClientIDMode="Static">
                                    <asp:ListItem Selected="True" Text="Credit" Value="4"> </asp:ListItem>
                                    <asp:ListItem Text="Cash" Value="1"> </asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-3">
                                <button style="width: 100%; padding: 0px;" class="label label-important" type="button"><span id="lblTotalLabItemsCount" style="font-size: 14px; font-weight: bold;">Count : 0</span></button>
                            </div>
                            <div class="col-md-2">
                                <%--Before Enabling This Button Kindly Test the Concept of Return Invoice Carefully--%>
                                <input type="button" id="btnAddReturn" class="ItDoseButton" value="Add Return QTY" style="width: 100px; display: none;" />

                            </div>
                            <div class="col-md-3">
                                <input id="btnAddNewItem" class="ItDoseButton" onclick="wopen('ItemMaster.aspx?Mode=1', 'popup1', 940, 550); return false;" type="button" value="Add New" style="width: 100px; display: none;" />
                            </div>
                        </div>
                        <div class="row" style="display: none;">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Tax Calculate On
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-13">
                                <asp:RadioButtonList ID="rblTaxCal" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" Style="font-size: 10px;">
                                    <asp:ListItem Text="MRP" Value="MRP"></asp:ListItem>
                                    <asp:ListItem Text="Rate" Value="Rate"></asp:ListItem>
                                    <asp:ListItem Text="RateAD" Value="RateAD" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Rate Rev." Value="RateRev"></asp:ListItem>
                                    <asp:ListItem Text="Rate Excl." Value="RateExcl"></asp:ListItem>
                                    <asp:ListItem Text="MRP Excl." Value="MRPExcl"></asp:ListItem>
                                    <asp:ListItem Text="Excise Amt." Value="ExciseAmt"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>

                        <div class="col-md-1"></div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Order Items Detail
                </div>
                <div class="row" style="margin: 0; padding: 0;">

                    <div class="col-md-24 " style="height: 320px; overflow-y: auto; margin: 0; padding: 0;" id="divItemsList">
                        <table id="tb_ItemsList" style="border-collapse: collapse; margin: 0; padding: 0; overflow-y: scroll;">
                            <thead style="width: 100%;">
                                <tr id="tHead">
                                     <th class="GridViewHeaderStyle" style="width: 30px">Add Free QTY</th>
                                    <th class="GridViewHeaderStyle" style="width: 20px"></th>
                                    <th class="GridViewHeaderStyle" style="width: 20px"></th>
                                    <th class="GridViewHeaderStyle" style="width: 50px; display:none">Update Master</th>
                                    <th class="GridViewHeaderStyle" style="width: 120px">Item Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 35px">Pur. Unit</th>
                                    <th class="GridViewHeaderStyle" style="width: 35px">Sales Unit</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px">HSN Code</th>
                                    <th class="GridViewHeaderStyle" style="width: 20px">Tax</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px">Rate</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px">MRP</th>

                                    <th class="GridViewHeaderStyle" style="width: 40px">Batch No</th>
                                   <%--  <th class="GridViewHeaderStyle" style="width: 40px">Model No</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px">Serial No</th>--%>

                                    <th class="GridViewHeaderStyle" style="width: 30px">GST Type</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px">CGST (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px">SGST/ UTGST (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px">IGST (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 20px">Disc (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px">Disc. Amt</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px">Spcl Disc (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px; display: none;">Spcl Disc Amt</th>

                                    <%--  Asset Start  --%>

                                   
                                    <th class="GridViewHeaderStyle" style="width: 40px; display: none;">Asset No</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px; display: none;">Inst.Date</th>
                                    

                                    <%--  Asset End  --%>
                                    <th class="GridViewHeaderStyle" style="width: 20px">QTY</th>
                                    
                                    <th class="GridViewHeaderStyle" style="width: 100px; display: none;">Free Service From</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px; display: none;">Free Service To</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px; display: none;">Warranty No</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px; display: none;">Warranty From</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px; display: none;">Warranty To</th>

                                    <th class="GridViewHeaderStyle" style="width: 70px; display:none;">Exp Date</th>                                   
                                    
                                </tr>
                            </thead>
                            <tbody style="width: 100%;"></tbody>
                        </table>
                    </div>

                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Gross Amount</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtBillGrossAmt" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bill Disc(%)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtBillDiscPer" autocomplete="off" onblur="$UpdateFinalDiscount(function(){});" onkeypress="return checkForSecondDecimal(this,event);" onkeyup="$ValidateDiscount(1,function(){});" maxlength="10" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bill Disc Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtBillDiscAmt" autocomplete="off" onblur="$UpdateFinalDiscount(function(){});" onkeypress="return checkForSecondDecimal(this,event);" onkeyup="$ValidateDiscount(1,function(){});" maxlength="10" />
                                <input type="text" id="txtTotalItemWiseDisc" autocomplete="off" maxlength="10" disabled="disabled" style="display: none;" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Round Off</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtRoundOff" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">GRN Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtInvoiceAmount" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">CGST Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtTotalCGST" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">SGST Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtTotalSGST" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">IGST Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtTotalIGST" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Narration</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine"
                                    CssClass="ItDoseTextinputText requiredField" AccessKey="N" ClientIDMode="Static"> </asp:TextBox>
                            </div>
                        </div>
                         <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Frieght Charges</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtFrieghtCharges" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" />
                            </div>
                             </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: aqua" class="circle"></button>
                <b style="float: left; margin-top: 5px; margin-left: 5px">Free Items</b>
                <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #e0fff6" class="circle"></button>
                <b style="float: left; margin-top: 5px; margin-left: 5px">Multiple Items</b>
                <input type="button" id="btnSaveGRN" value="Save" class="ItDoseButton" style="width: 100px; margin-top: 7px;" onclick="$SaveGRN(this, function () { });" />
                <input type="button" id="btnCancelGRN" value="Cancel" class="ItDoseButton" style="width: 100px; margin-top: 7px;" onclick="$clear();" />

            </div>
        </asp:Panel>

        <div id="divAddReturn" class="modal fade ">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 1000px; height: 130px">
                    <div class="modal-header">
                        <button type="button" class="close" aria-hidden="true" data-dismiss="divAddReturn">&times;</button>
                        <h4 class="modal-title">Add Return Items
                            <label id="lblErrorReturn" class="ItDoseLblError"></label>
                        </h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-24">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Supplier</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <label id="lblSupplierName" class="pull-left"></label>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">Item</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-7">
                                        <asp:DropDownList ID="ddlReturnItems" runat="server" ClientIDMode="Static">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">QTY</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-2">
                                        <input type="text" id="txtReturnQty" class="requiredField" onlynumber="5" />
                                    </div>
                                    <div class="col-md-2">
                                        <input id="btnAddReturnItem" type="button" class="ItDoseButton" value="Add" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="modal-footer" align="center">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divUpdateItemMaster" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 350px; height: 315px">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" data-dismiss="divUpdateItemMaster">&times;</button>
                    <h4 class="modal-title">Update Item master :
                        <label id="lblUpdateItemName" class="ItDoseLblError"></label>
                    </h4>
                    <span id="spnUpdateRowId" style="display: none;"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="cbUpdateCF" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    Con. Fac. :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateCF" onkeypress="return checkForSecondDecimal(this,event);" maxlength="5" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="cbUpdateHSNCode" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    HSN Code :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateHSNCode" maxlength="20" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="cbUpdateGSTType" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    GST Type :
                                </div>
                                <div class="col-md-14">
                                    <asp:DropDownList ID="ddlUpdateGSTType" runat="server" ClientIDMode="Static" onchange="$changeUpdateGSTType()"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    CGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateCGSTPer" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    SGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateSGSTPer" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    IGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateIGSTPer" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="cbUpDateIsExpirable" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    IsExpirable :
                                </div>
                                <div class="col-md-14">
                                    <input type="checkbox" id="cbUpDateIsExpirableValue" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="text-align: center;">
                    <input type="button" value="OK" style="margin-top: 7px; width: 100px;" onclick="$BindUpdates()" />
                </div>
            </div>
        </div>
    </div>
    <style>
        .GridViewItemStyle {
            padding: 1px;
        }

            .GridViewItemStyle input[type="text"] {
                padding: 1px;
            }
    </style>
    <script>
        $(document).ready(function () {
            $('#ddlVendor').chosen();
            $('#tb_ItemsList tbody').empty();
            $addNewRow(1, 0, function () { $('.chosen-single').focus(); });

            $('#btnAddReturn').click(function () {
                if ($validateControls()) {
                    $checkDuplicateInvoice(function (response) {
                        if (!response) {
                            $disableControls();
                            $getReturnItemsList(function () {
                                $('#btnAddReturnItem').click(function () {
                                    $validateReturnItem(function () {

                                    });
                                });
                            });
                        }
                    });
                }
            });
        });
        $addNewRow = function (id, isFree, callback) {
            
            $AddItems(id, isFree, function () {
                $bindGSTType(id, function () {
                    $bindAutoComplete(id, function () {
                        // $bindExpiry(id, function () {

                        $bindCal(id, function () { });
                        $updateCount(id, function () { });
                        //  });
                    });
                });
            });
            callback(true);
        }

        $addQtyRow = function (id, isFree, Qty, callback) {
            var qty = $(Qty).val() - 1;
            $("#" + Qty.id).val(1);
            $("#" + Qty.id).prop("disabled", true)
            for (var n = 0; n < qty; n++) {
                $AddQtyItems(id, 0, function () {
                   
                        $bindAutoComplete(id, function () {
                            // $bindExpiry(id, function () {
                            $bindCal(id, function () { });
                            $updateCount(id, function () { });
                            //  });
                        });
                   
                    id = id + 1;

                });
            }

            callback(true);
        }

        $removeRow = function (elem, callback) {
            $(elem).closest('tr').remove();
            if (parseFloat($('#tb_ItemsList tbody tr').length) == 0)
                $addNewRow(1, 0, function () { $enableControls(); });
            else
                $updateCount($(elem).closest('tr').attr('id'), function () { });
            $UpdateAmounts(function () { });
            callback(true);

        }
        $AddItems = function (id, IsFree, callback) {
            $isRequiredClass = "";
            if ($('#rblStoreType').find(':checked').val() == "STO00001")
                $isRequiredClass = "requiredField";
            $('#tb_ItemsList tbody').append('<tr id="tr_' + id + '"></tr>')
            $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnAddFree_' + id + '" src="../../Images/plus_blue.png" onclick="$addNewRow(' + (id + 1) + ',1,function(){})" style="cursor:pointer;" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnAdd_' + id + '" src="../../Images/plus_in.gif" onclick="$addNewRow(' + (id + 1) + ',0,function(){})" style="cursor:pointer;" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnRemove_' + id + '" src="../../Images/Delete.gif" onclick="$removeRow(this,function(){})" style="cursor:pointer;" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"  style="display:none;" align="center"><img src="../../Images/Post.gif" style="cursor:pointer;" onclick="$UpdateMaster(' + id + ',function(){})" /> </td>');

            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtItemName_' + id + '" tabindex="' + (id * 100 + 1) + '" class="requiredField" autocomplete="off" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><span id="spnPurUnit_' + id + '"></span></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><span id="spnSalesUnit_' + id + '"></span></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtHSNCode_' + id + '" tabindex="' + (id * 100 + 3) + '"  maxlength="10" autocomplete="off" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><select id="ddlTaxCalOn_' + id + '"  tabindex="' + (id * 100 + 4) + '" onchange="$getTaxCalculations(' + id + ',function(){});" ></select></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtRate_' + id + '"  tabindex="' + (id * 100 + 7) + '" maxlength="10" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtMrp_' + id + '" maxlength="10" tabindex="' + (id * 100 + 8) + '" class="' + $isRequiredClass + '" onkeypress="return checkForSecondDecimal(this,event);"   /></td>');

            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtBatchNo_' + id + '" maxlength="10" tabindex="' + (id * 100 + 10) + '" class="' + $isRequiredClass + '" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text"  id="txtModelNo_' + id + '"  tabindex="' + (id * 100 + 18) + '" onkeypress="return checkForSecondDecimal(this,event);" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtSerialNo_' + id + '" tabindex="' + (id * 100 + 22) + '"  onkeypress="return checkForSecondDecimal(this,event);"  /></td>');

            $('#tr_' + id).append('<td class="GridViewItemStyle"><select id="ddlGSTType_' + id + '" tabindex="' + (id * 100 + 11) + '" onchange=" $changeTaxType(' + id + ', function () { $getTaxCalculations(' + id + ',function(){});})" ></select></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtCGST_' + id + '" tabindex="' + (id * 100 + 12) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" disabled="disabled"  /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtSGST_' + id + '" tabindex="' + (id * 100 + 13) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});"  disabled="disabled"  /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtIGST_' + id + '" tabindex="' + (id * 100 + 14) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" disabled="disabled"  /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtDiscPer_' + id + '" tabindex="' + (id * 100 + 15) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtDiscAmt_' + id + '" tabindex="' + (id * 100 + 16) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtSpclDiscPer_' + id + '" tabindex="' + (id * 100 + 17) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtSpclDiscAmt_' + id + '"  maxlength="5" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');

            //Asset GRN

          
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtAssetTagNo_' + id + '" tabindex="' + (id * 100 + 19) + '" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtInstallationDate_' + id + '" tabindex="' + (id * 100 + 20) + '" class="requiredField"   /></td>');
           
            //$('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtServiceFrom_' + id + '" tabindex="' + (id * 100 + 23) + '" class="requiredField"   /></td>');
            //$('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtServiceTo_' + id + '"   tabindex="' + (id * 100 + 24) + '"  class="requiredField"   /></td>');
            //$('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtServiceFrom_' + id + '" tabindex="' + (id * 100 + 23) + '" class="requiredField"   /></td>');
            //$('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtServiceTo_' + id + '"   tabindex="' + (id * 100 + 24) + '"  class="requiredField"   /></td>');



            //Asset GRN End
            $('#tr_' + id).append('<td class="GridViewItemStyle" ><input type="text" id="txtQty_' + id + '" maxlength="10" class="requiredField" tabindex="' + (id * 100 + 21) + '" value="1" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){})" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;" ><input type="text" id="txtFree_ServiceFrom_' + id + '" tabindex="' + (id * 100 + 23) + '" class="requiredField"   /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtFree_ServiceTo_' + id + '"   tabindex="' + (id * 100 + 24) + '" class="requiredField"     /></td>');

            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyNo_' + id + '"       tabindex="' + (id * 100 + 25) + '" class="requiredField"       /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyFrom_' + id + '"     tabindex="' + (id * 100 + 26) + '" class="requiredField"         /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyTo_' + id + '"     tabindex="' + (id * 100 + 27) + '" class="requiredField"         /></td>');



            $('#tr_' + id).append('<td class="GridViewItemStyle"  style="display:none;"><input type="text" id="txtExp_' + id + '" maxlength="5" placeholder="mm/YY" tabindex="' + (id * 100 + 28) + '" onkeypress="return validateCharacter(this,event,' + id + ');" onkeyup="return validateExpiry(this,event);" ToolTip="Press Enter to Add New Row" /></td>');
         
          
            $('#tr_' + id).append('<td style="display:none;"><span id="spnItemName_' + id + '" ></span><span id="spnItemId_' + id + '" ></span><span id="spnIsExpirable_' + id + '"></span><span id="spnSubCategoryID_' + id + '"></span><span id="spnIsUpdateCF_' + id + '">0</span> <span id="spnIsUpdateHSNCode_' + id + '">0</span><span id="spnIsUpdateGST_' + id + '">0</span><span id="spnIsUpdateExpirable_' + id + '">0</span></td>');
            $('#tr_' + id).append('<td style="display:none;"><span id="spnCGSTAmt_' + id + '">0</span><span id="spnSGSTAmt_' + id + '">0</span><span id="spnIGSTAmt_' + id + '">0</span><span id="spnNetAmount_' + id + '">0</span><span id="spnDiscPer_' + id + '">0</span><span id="spnDiscAmt_' + id + '">0</span><span id="spnSpclDiscPer_' + id + '">0</span><span id="spnSpclDiscAmt_' + id + '">0</span><span id="spnGrossAmt_' + id + '">0</span><span id="spnUnitPrice_' + id + '">0</span><span id="spnStockId_' + id + '"></span><span id="spnIsReturn_' + id + '">0</span><span id="spnGRNNo_' + id + '"></span><span id="spnInvoiceNo_' + id + '"></span><span id="spnIsFree_' + id + '">' + IsFree + '</span><span id="spnIsOnSellingPrice' + id + '">0</span><span id="spnSellingMargin' + id + '">0.00</span></td>');

            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateAD").text("RateAD"));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "Rate").text("Rate"));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateRev").text("Rate Rev."));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateExcl").text("Rate Excl."));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "MRP").text("MRP"));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "MRPExcl").text("MRP Excl."));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "ExciseAmt").text("Excise Amt."));
            if (IsFree == "1")
                $setFreeRow(id, function () { });
            $('#divItemsList').customFixedHeader();


            if ($('#ddlGSTType_' + id).val() == "T4") {
                $('#txtIGST_' + id).removeAttr('disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).attr('disabled', 'disabled');
            }
            else if ($('#ddlGSTType_' + id).val() == "T7") {
                $('#txtIGST_' + id).attr('disabled', 'disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).removeAttr('disabled');
            }
            else {
                $('#txtIGST_' + id).attr('disabled', 'disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).removeAttr('disabled');
            }


            callback(true);
        }
        $bindAutoComplete = function (id, callback) {
            $('#txtItemName_' + id).autocomplete({
                source: function (request, response) {
                    $ItemName = this.element[0].value;
                    $bindItems({ ItemName: $ItemName, StoreLedgerNo: $('#rblStoreType').find(':checked').val() }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (event, ui) {
                    var label = ui.item.label;
                    var value = ui.item.ItemId;

                    var response = $validateControls();
                    if (response) {
                        $checkDuplicateInvoice(function (response) {
                            if (!response) {
                                $disableControls();
                                $('#txtItemName_' + id).val(label);
                                $('#spnItemName_' + id).text(label);
                                $('#spnItemId_' + id).text(value.split('#')[0]);
                                if (value.split('#')[1] == "NO") {
                                    $('#txtExp_' + id).val('').attr('disabled', 'disabled');
                                    $('#spnIsExpirable_' + id).text('0');
                                }
                                else {
                                    $('#txtExp_' + id).removeAttr('disabled');
                                    $('#spnIsExpirable_' + id).text('1');

                                }
                                $('#spnSalesUnit_' + id).text(value.split('#')[2]);
                                $('#spnPurUnit_' + id).text(value.split('#')[4]);
                                $('#txtHSNCode_' + id).val(value.split('#')[6]);
                                if (value.split('#')[5] == "IGST") {
                                    $('#ddlGSTType_' + id).val("T4");
                                    $('#txtIGST_' + id).removeAttr('disabled');
                                    $('#txtCGST_' + id + ',#txtSGST_' + id).attr('disabled', 'disabled');
                                }
                                else if (value.split('#')[5] == "CGST&UTGST") {
                                    $('#ddlGSTType_' + id).val("T7");
                                    $('#txtIGST_' + id).attr('disabled', 'disabled');
                                    $('#txtCGST_' + id + ',#txtSGST_' + id).removeAttr('disabled');

                                }
                                else {
                                    $('#ddlGSTType_' + id).val("T6");
                                    $('#txtIGST_' + id).attr('disabled', 'disabled');
                                    $('#txtCGST_' + id + ',#txtSGST_' + id).removeAttr('disabled');
                                }
                                $('#txtCGST_' + id).val(value.split('#')[7]);
                                $('#txtSGST_' + id).val(value.split('#')[8]);
                                $('#txtIGST_' + id).val(value.split('#')[9]);
                                $('#spnSubCategoryID_' + id).text(value.split('#')[10]);
                                $('#spnIsOnSellingPrice' + id).text(value.split('#')[11]);
                                $('#spnSellingMargin' + id).text(value.split('#')[12]);


                            }
                            else {
                                $('#txtItemName_' + id).val('');
                                //$enableControls();
                            }

                        });
                    }
                    else {
                        $('#txtItemName_' + id).val('');
                    }
                },
                focus: function (event, ui) {
                    $('#txtItemName_' + id).val('');
                },
                close: function (el) {
                    el.target.value = $('#spnItemName_' + id).text();
                },
                minLength: 2
            });
            $bindItems = function (data, callback) {
                serverCall('Services/WebService.asmx/GetItemList', data, function (response) {
                    var responseData = $.map(response, function (item) {
                        return {
                            label: item.itemName,
                            ItemId: item.itemID
                        }
                    });
                    callback(responseData);
                });
            }
            callback(true);
        }
        $bindExpiry = function (id, callback) {
            $('#txtExp_' + id).attr('readonly', 'readonly').datepicker({
                dateFormat: 'dd-M-yy',
                minDate: '+1D',
                changeMonth: true,
                changeYear: true
            });
            callback(true);
        }
        $bindCal = function (id, callback) {
            $('#txtInstallationDate_' + id + ',#txtFree_ServiceFrom_' + id + ',#txtFree_ServiceTo_' + id + ',#txtWarrantyFrom_' + id + ',#txtWarrantyTo_' + id).attr('readonly', 'readonly').datepicker({
                dateFormat: 'dd-M-yy',
                minDate: '+1D',
                changeMonth: true,
                changeYear: true
            });
            callback(true);
        }

        $updateCount = function (id, callback) {
            $('#lblTotalLabItemsCount').text('Count : ' + $('#tb_ItemsList tbody tr').length);
            $('#btnAdd_' + (id - 1) + ',#btnAddFree_' + (id - 1)).hide();
            $('#btnAdd_' + $('#tb_ItemsList tbody tr:last').attr('id').split('_')[1] + ',#btnAddFree_' + $('#tb_ItemsList tbody tr:last').attr('id').split('_')[1]).show();
            if (id != "1")
                $('#txtItemName_' + $('#tb_ItemsList tbody tr:last').attr('id').split('_')[1]).focus();
            callback(true);
        }
        $previewCountDigit1 = function (e, callback) {
            $('#tooltip' + e.target.id).addClass('visible');
            $('#tooltip' + e.target.id + ' span').text('Count: ' + e.target.value.length);
            callback(e);
        };
        $bindGSTType = function (id, callback) {
            $('#ddlGSTType_' + id).empty();
            serverCall('Services/WebService.asmx/bindGSTType', callback, function (response) {
                var Data = $.parseJSON(response);
                for (var i = 0; i < Data.length; i++) {
                    $('#ddlGSTType_' + id).append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                }
                callback(true);
            });
            callback(true);
        }
        $changeTaxType = function (id, callback) {
            if ($('#ddlGSTType_' + id).val() == "T4") {
                $('#txtIGST_' + id).removeAttr('disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).attr('disabled', 'disabled');
            }
            else {
                $('#txtIGST_' + id).attr('disabled', 'disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).removeAttr('disabled');
            }
            $('#txtCGST_' + id + ',#txtSGST_' + id + ',#txtIGST_' + id).val('0.0000');
            callback(true);
        }
        $getTaxCalculations = function (id, callback) {
            $DiscPer = 0; $DiscAmt = 0; $Rate = 0; $MRP = 0; $QTY = 0; $spclDiscPer = 0; $spclDiscAmt = 0;
            $CGSTPer = 0; $SGSTPer = 0; $IGSTPer = 0; $BillDiscPer = 0; $BillDiscAmt = 0; $BillGrossAmt = 0;
            $Type = $('#ddlTaxCalOn_' + id).val();
            if ($.trim($('#txtDiscPer_' + id).val()) != "")
                $DiscPer = parseFloat($.trim($('#txtDiscPer_' + id).val()));
            if ($.trim($('#txtDiscAmt_' + id).val()) != "" && $('#spnIsFree_' + id).text() == "0")
                $DiscAmt = parseFloat($.trim($('#txtDiscAmt_' + id).val()));
            if ($.trim($('#txtRate_' + id).val()) != "" && $('#spnIsFree_' + id).text() == "0")
                $Rate = parseFloat($.trim($('#txtRate_' + id).val()));
            if ($.trim($('#txtMrp_' + id).val()) != "")
                $MRP = parseFloat($.trim($('#txtMrp_' + id).val()));
            if ($.trim($('#txtQty_' + id).val()) != "")
                $QTY = parseFloat($.trim($('#txtQty_' + id).val()));
            if ($.trim($('#txtSpclDiscPer_' + id).val()) != "")
                $spclDiscPer = parseFloat($.trim($('#txtSpclDiscPer_' + id).val()));
            if ($.trim($('#txtSpclDiscAmt_' + id).val()) != "" && $('#spnIsFree_' + id).text() == "0")
                $spclDiscAmt = parseFloat($.trim($('#txtSpclDiscAmt_' + id).val()));
            if ($.trim($('#txtCGST_' + id).val()) != "")
                $CGSTPer = parseFloat($.trim($('#txtCGST_' + id).val()));
            if ($.trim($('#txtSGST_' + id).val()) != "")
                $SGSTPer = parseFloat($.trim($('#txtSGST_' + id).val()));
            if ($.trim($('#txtIGST_' + id).val()) != "")
                $IGSTPer = parseFloat($.trim($('#txtIGST_' + id).val()));
            if ($('#txtBillDiscPer').val() != "")
                $BillDiscPer = parseFloat($.trim($('#txtBillDiscPer').val()));
            if ($('#txtBillDiscAmt').val() != "")
                $BillDiscAmt = parseFloat($.trim($('#txtBillDiscAmt').val()));
            if ($('#txtBillGrossAmt').val() != "")
                $BillGrossAmt = parseFloat($.trim($('#txtBillGrossAmt').val()));
            serverCall('Services/WebService.asmx/TaxCalculation', { BillDiscPer: $BillDiscPer, BillDiscAmt: $BillDiscAmt, BillGrossAmt: $BillGrossAmt, DiscPer: $DiscPer, DiscAmt: $DiscAmt, Rate: $Rate, MRP: $MRP, QTY: $QTY, spclDiscPer: $spclDiscPer, spclDiscAmt: $spclDiscAmt, CGSTPer: $CGSTPer, SGSTPer: $SGSTPer, IGSTPer: $IGSTPer, Type: $Type }, function (response) {

                $Data = response;
                $('#spnNetAmount_' + id).text($Data.split('#')[0]);
                $('#spnIGSTAmt_' + id).text($Data.split('#')[8]);
                $('#spnCGSTAmt_' + id).text($Data.split('#')[9]);
                $('#spnSGSTAmt_' + id).text($Data.split('#')[10]);
                $('#spnDiscPer_' + id).text($Data.split('#')[12]);
                $('#spnDiscAmt_' + id).text($Data.split('#')[2]);
                $('#spnSpclDiscPer_' + id).text($Data.split('#')[13]);
                $('#spnSpclDiscAmt_' + id).text($Data.split('#')[11]);
                $('#spnGrossAmt_' + id).text($Data.split('#')[3]);
                $('#spnUnitPrice_' + id).text($Data.split('#')[4]);
                $isOnSellingPrice = parseInt($.trim($('#spnIsOnSellingPrice' + id).text()));
                $SellingMarginPer = parseFloat($.trim($('#spnIsOnSellingPrice' + id).text()));
                if ($isOnSellingPrice == 1) {
                    $marginAmt = parseFloat((parseFloat($Data.split('#')[4]) * $SellingMarginPer) / 100);
                    $NetMRPAmt = Number(parseFloat($Data.split('#')[4]) + $marginAmt).toFixed(2);
                    $('#txtMrp_' + id).val($NetMRPAmt);

                }


                $UpdateAmounts(function () { });
            });



            callback(true);
        }
        $UpdateAmounts = function (callback) {
            $NetAmt = 0; $RoundOff = 0; $CGSTAmt = 0; $SGSTAmt = 0; $IGSTAmt = 0; $TempAmt = 0;
            $DiscAmt = 0; $GrossAmt = 0;
            $('#tb_ItemsList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('id').split('_')[1];
                if ($('#spnIsReturn_' + $rowid).text() == "1") {
                    $NetAmt -= parseFloat($('#spnNetAmount_' + $rowid).text());
                    $CGSTAmt -= parseFloat($('#spnCGSTAmt_' + $rowid).text());
                    $SGSTAmt -= parseFloat($('#spnSGSTAmt_' + $rowid).text());
                    $IGSTAmt -= parseFloat($('#spnIGSTAmt_' + $rowid).text());
                    $GrossAmt -= parseFloat($('#spnGrossAmt_' + $rowid).text());
                    $DiscAmt -= parseFloat($('#spnDiscAmt_' + $rowid).text());
                }
                else {

                    $NetAmt += parseFloat($('#spnNetAmount_' + $rowid).text());
                    $CGSTAmt += parseFloat($('#spnCGSTAmt_' + $rowid).text());
                    $SGSTAmt += parseFloat($('#spnSGSTAmt_' + $rowid).text());
                    $IGSTAmt += parseFloat($('#spnIGSTAmt_' + $rowid).text());
                    $GrossAmt += parseFloat($('#spnGrossAmt_' + $rowid).text());
                    $DiscAmt += parseFloat($('#spnDiscAmt_' + $rowid).text());
                }

            });
            $('#txtTotalIGST').val(Number($IGSTAmt).toFixed(4));
            $('#txtTotalCGST').val(Number($CGSTAmt).toFixed(4));
            $('#txtTotalSGST').val(Number($SGSTAmt).toFixed(4));
            $('#txtBillGrossAmt').val(Number($GrossAmt).toFixed(2));

            $TempAmt = Number($NetAmt).toFixed(0);
            $RoundOff = Number(parseFloat($TempAmt) - parseFloat($NetAmt)).toFixed(2);
            $('#txtRoundOff').val($RoundOff);
            $('#txtInvoiceAmount').val($TempAmt);
            $('#txtTotalItemWiseDisc').val(Number($DiscAmt).toFixed(2));
            callback(true);
        }
        $ValidateDiscount = function (id, callback) {
            $('#txtBillDiscAmt,#txtBillDiscPer').removeAttr('disabled');
            $('#txtBillDiscAmt').show();
            $('#txtTotalItemWiseDisc').hide();
            $('#tb_ItemsList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('id').split('_')[1];
                if ($.trim($('#txtDiscPer_' + id).val()) != "" || $.trim($('#txtDiscAmt_' + id).val()) != "" || $.trim($('#txtSpclDiscPer_' + id).val()) != "" || $.trim($('#txtSpclDiscAmt_' + id).val()) != "") {
                    $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
                    $('#txtBillDiscAmt').hide();
                    $('#txtTotalItemWiseDisc').show();

                }
            });
            $DiscPer = 0; $DiscAmt = 0; $Rate = 0; $QTY = 0; $spclDiscPer = 0; $spclDiscAmt = 0;
            $BillDiscPer = 0; $BillDiscAmt = 0; $BillGrossAmt = 0;
            if ($.trim($('#txtDiscPer_' + id).val()) != "")
                $DiscPer = parseFloat($.trim($('#txtDiscPer_' + id).val()));
            if ($.trim($('#txtDiscAmt_' + id).val()) != "")
                $DiscAmt = parseFloat($.trim($('#txtDiscAmt_' + id).val()));
            if ($.trim($('#txtRate_' + id).val()) != "")
                $Rate = parseFloat($.trim($('#txtRate_' + id).val()));
            if ($.trim($('#txtQty_' + id).val()) != "")
                $QTY = parseFloat($.trim($('#txtQty_' + id).val()));
            if ($.trim($('#txtSpclDiscPer_' + id).val()) != "")
                $spclDiscPer = parseFloat($.trim($('#txtSpclDiscPer_' + id).val()));
            if ($.trim($('#txtSpclDiscAmt_' + id).val()) != "")
                $spclDiscAmt = parseFloat($.trim($('#txtSpclDiscAmt_' + id).val()));
            if ($('#txtBillDiscPer').val() != "")
                $BillDiscPer = parseFloat($.trim($('#txtBillDiscPer').val()));
            if ($('#txtBillDiscAmt').val() != "")
                $BillDiscAmt = parseFloat($.trim($('#txtBillDiscAmt').val()));
            if ($('#txtBillGrossAmt').val() != "")
                $BillGrossAmt = parseFloat($.trim($('#txtBillGrossAmt').val()));

            if ($DiscPer != 0) {
                $('#txtDiscAmt_' + id).val('');
                $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
                $('#txtBillDiscAmt').hide();
                $('#txtTotalItemWiseDisc').show();
            }
            if ($DiscAmt != 0) {
                $('#txtDiscPer_' + id).val('');
                $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
                $('#txtBillDiscAmt').hide();
                $('#txtTotalItemWiseDisc').show();
            }
            if ($DiscPer > 100) {
                alert('Discount Cannot be Greater than 100%');
                $('#txtDiscPer_' + id).val('');
                return false;
            }
            debugger
            if (($Rate * $QTY) < $DiscAmt) {
                alert('Discount Amount cannot be Greater than Gross Amount');
                $('#txtDiscAmt_' + id).val('');
            }
            if ($spclDiscPer != 0) {
                $('#txtSpclDiscAmt_' + id).val('');
                $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
            }
            if ($spclDiscAmt != 0) {
                $('#txtSpclDiscPer_' + id).val('');
                $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
            }
            if ($spclDiscPer > 100) {
                alert('Discount Cannot be Greater than 100%');
                $('#txtSpclDiscPer_' + id).val('');
            }
            if ($BillDiscPer != 0) {
                $('#txtBillDiscAmt').val('');
            }
            if ($BillDiscAmt != 0) {
                $('#txtBillDiscPer').val('');
            }
            if ($BillDiscPer > 100) {
                alert('Discount Cannot be Greater than 100%');
                $('#txtBillDiscPer').val('');
            }
            if ($BillDiscAmt > $BillGrossAmt) {
                alert('Total Discount Amount cannot be greater than Gross Amount');
                $('#txtBillDiscAmt').val('');
            }
            callback(true);

        }
        $ValidateMRP = function (id, callback) {
            $rate = 0; $MRP = 0; $unitPrice = 0;
            if ($('#txtRate_' + id).val() != "")
                $rate = parseFloat($.trim($('#txtRate_' + id).val()));
            if ($('#txtMrp_' + id).val() != "")
                $MRP = parseFloat($.trim($('#txtMrp_' + id).val()));
           
            if ($rate > $MRP) {
                alert('MRP cannot be less than Rate');
                $('#txtMrp_' + id).focus();
            }

            callback(true);
        }
        $UpdateFinalDiscount = function (callback) {
            $('#tb_ItemsList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('id').split('_')[1];
                $getTaxCalculations($rowid, function () { });
            });
            callback(true);
        }
        $setFreeRow = function (id, callback) {
            $('#txtItemName_' + id).val($('#txtItemName_' + (id - 1)).val());
            $('#spnPurUnit_' + id).text($('#spnPurUnit_' + (id - 1)).text());
            $('#spnSalesUnit_' + id).text($('#spnSalesUnit_' + (id - 1)).text());
            $('#txtHSNCode_' + id).val($('#txtHSNCode_' + (id - 1)).val());
            $('#ddlTaxCalOn_' + id).val($('#ddlTaxCalOn_' + (id - 1)).val());
            //$('#txtDeal1_' + id).val($('#txtDeal1_' + (id - 1)).val());
            //$('#txtDeal2_' + id).val($('#txtDeal2_' + (id - 1)).val());
            $('#txtRate_' + id).val($('#txtRate_' + (id - 1)).val());
            $('#txtMrp_' + id).val($('#txtMrp_' + (id - 1)).val());
            $('#txtBatchNo_' + id).val($('#txtBatchNo_' + (id - 1)).val());
            $('#ddlGSTType_' + id).val($('#ddlGSTType_' + (id - 1)).val());
            $('#txtCGST_' + id).val($('#txtCGST_' + (id - 1)).val());
            $('#txtSGST_' + id).val($('#txtSGST_' + (id - 1)).val());
            $('#txtIGST_' + id).val($('#txtIGST_' + (id - 1)).val());
            $('#txtDiscPer_' + id).val($('#txtDiscPer_' + (id - 1)).val());
            $('#txtDiscAmt_' + id).val($('#txtDiscAmt_' + (id - 1)).val());
            $('#txtSpclDiscPer_' + id).val($('#txtSpclDiscPer_' + (id - 1)).val());
            $('#txtSpclDiscAmt_' + id).val($('#txtSpclDiscAmt_' + (id - 1)).val());
            $('#txtExp_' + id).val($('#txtExp_' + (id - 1)).val());
            $('#spnItemName_' + id).text($('#spnItemName_' + (id - 1)).text());
            $('#spnItemId_' + id).text($('#spnItemId_' + (id - 1)).text());
            $('#spnIsExpirable_' + id).text($('#spnIsExpirable_' + (id - 1)).text());
            $('#spnSubCategoryID_' + id).text($('#spnSubCategoryID_' + (id - 1)).text());
            $('#spnIsUpdateCF_' + id).text('0');
            $('#spnIsUpdateHSNCode_' + id).text('0');
            $('#spnIsUpdateGST_' + id).text('0');
            $('#spnIsUpdateExpirable_' + id).text('0');
            $("#tr_" + id).css("background-color", "aqua");
            $getTaxCalculations(id, function () { });
            callback(true);
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));

                if ((charCode != 46) && ((charCode < 48) || (charCode > 57))) {
                    return false;
                }
                else {
                    if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
            }
            return true;
        }
        function validateCharacter(sender, e, rowId) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;

            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if (charCode == 10) {
                    $newId = (parseInt($('#tb_ItemsList tbody tr:last').attr('id').split('_')[1]) + 1);
                    $addNewRow($newId, 0, function () {
                        $updateCount($newId, function () { });
                    });
                }
                if ((charCode != 47) && ((charCode < 48) || (charCode > 57))) {
                    return false;
                }
                else {
                    if ((charCode == 47)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '/');
                            if (hasDec)
                                return false;
                        }
                    }
                }
            }
            if (strVal.charAt(2) != '/' && strVal.length > 2)
                return false;
            return true;

        }
        function validateExpiry(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                           ((e.keyCode) ? e.keyCode :
                           ((e.which) ? e.which : 0));
                if (strVal.charAt(0) == '/')
                    $(sender).val('01/');
                if (strVal.charAt(1) == '/')
                    $(sender).val('0' + strVal);
                if (strVal.charAt(2) == '/') {
                    if (parseFloat(strVal.split('/')[0]) > 12 || parseFloat(strVal.split('/')[0]) < 1) {
                        alert('Invalid Month');
                        $(sender).val('').focus();
                    }
                }
                if (strVal.length == 2 && charCode != 8 && strVal.charAt(1) != '/')
                    $(sender).val(strVal + '/');

                if (strVal.charAt(3) == '/' && charCode != 8)
                    $(sender).val(strVal.substring(0, 3));

                if (strVal.length == 5 && charCode != 8) {
                    if (parseFloat(strVal.split('/')[1]) < parseFloat($.datepicker.formatDate('y', new Date()))) {
                        alert('Expiry Date Cannot be less than Current Date');
                        $(sender).val('').focus();
                    }
                    else {
                        if ((parseFloat(strVal.split('/')[1]) == parseFloat($.datepicker.formatDate('y', new Date()))) && (parseFloat(strVal.split('/')[0]) < parseFloat($.datepicker.formatDate('mm', new Date(new Date().getTime() + 24 * 60 * 60 * 1000))))) {
                            alert('Expiry Date Cannot be less than Current Date');
                            $(sender).val('').focus();
                        }

                    }
                }

            }
        }
        $getReturnItemsList = function (callback) {
            if ($('#ddlVendor').val() == "0") {
                modelAlert('Please Select Vendor');
                callback(false);
            }
            else {
                $('#ddlReturnItems').chosen("destroy");
                $('#ddlReturnItems').empty();
                serverCall('Services/WebService.asmx/getReturnItems', { StoreType: $('#rblStoreType').find(':checked').val(), VendorLedgerNo: $('#ddlVendor').val().split('#')[0], DeptLedgerNo: ('<%= ViewState["DeptLedgerNo"].ToString()%>') }, function (response) {
                    var Data = $.parseJSON(response);
                    if (Data != "") {
                        for (var i = 0; i < Data.length; i++) {
                            $('#ddlReturnItems').append($("<option></option>").attr("value", Data[i].StockID).text(Data[i].Item));
                        }
                    }
                    else {

                        $('#ddlReturnItems').append($("<option></option>").attr("value", "0").text("--No Items Found--"));
                    }
                    $('#lblSupplierName').text($('#ddlVendor option:selected').text());
                    $('#divAddReturn').showModel();
                    $('#ddlReturnItems').chosen();
                });
                callback(true);
            }

        }
        $validateReturnItem = function () {
            $('#btnAddReturnItem').attr('disabled', 'disabled');
            $con = 0;
            $('#tb_ItemsList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('id').split('_')[1];
                if ($.trim($('#spnStockId_' + $rowid).text()) == $('#ddlReturnItems').val())
                    $con = 1;
            });
            if ($('#txtReturnQty').val() == "") {
                $('#lblErrorReturn').text('Please Enter Return QTY');
                $('#txtReturnQty').focus();
                return false;
            }
            else if ($con == 1) {
                $('#lblErrorReturn').text('Item Already Exist in List');
                $('#txtReturnQty').focus();
                return false;
            }
            else {
                $('#lblErrorReturn').text('');
                $getReturnItemDetails($('#ddlReturnItems').val(), $('#txtReturnQty').val(), function () {
                });
            }
            $('#btnAddReturnItem').removeAttr('disabled');
        }
        $getReturnItemDetails = function (stockId, ReturnQTY, callback) {
            serverCall('Services/WebService.asmx/bindGRNReturnItem', { StockId: stockId, ReturnQTY: ReturnQTY }, function (response) {
                $bindReturnItemRow($.parseJSON(response), ReturnQTY, function () {
                    $UpdateAmounts(function () { });
                });
            });
            callback(true);
        }
        $bindReturnItemRow = function (Data, ReturnQTY, callback) {
            var id = (parseInt($('#tb_ItemsList tbody tr:last').attr('id').split('_')[1]) + 1);
            if (Data != null) {
                $('#tb_ItemsList tbody').append('<tr id="tr_' + id + '"></tr>')
                $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnAddFree_' + id + '" src="../../Images/plus_blue.png" onclick="$addNewRow(' + (id + 1) + ',1,function(){})" style="cursor:pointer;" disabled=disabled></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnAdd_' + id + '" src="../../Images/plus_in.gif" onclick="$addNewRow(' + (id + 1) + ',0,function(){})" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnRemove_' + id + '" src="../../Images/Delete.gif" onclick="$removeRow(this,function(){})" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"  style="display:none;"><img src="../../Images/Post.gif" disabled="disabled"/></td>');

                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtItemName_' + id + '"  class="requiredField" autocomplete="off" value="' + Data[0].ItemName + '" disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><span id="spnPurUnit_' + id + '">' + Data[0].PurUnit + '</span></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><span id="spnSalesUnit_' + id + '">' + Data[0].SalesUnit + '</span></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtHSNCode_' + id + '" maxlength="10" autocomplete="off" value="' + Data[0].HSNCode + '" disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><select id="ddlTaxCalOn_' + id + '" onchange="$getTaxCalculations(' + id + ',function(){})" disabled="disabled" ></select></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtRate_' + id + '" maxlength="10" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" value="' + Data[0].PurRate + '" disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtMrp_' + id + '" maxlength="10" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" value="' + Data[0].MRP + '" disabled="disabled"  /></td>');

                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtBatchNo_' + id + '" maxlength="10" class="requiredField" value="' + Data[0].BatchNumber + '" disabled="disabled"  /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtModelNo_' + id + '" onkeypress="return checkForSecondDecimal(this,event);" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtSerialNo_' + id + '" onkeypress="return checkForSecondDecimal(this,event);" /></td>');

                $('#tr_' + id).append('<td class="GridViewItemStyle"><select id="ddlGSTType_' + id + '" onchange=" $changeTaxType(' + id + ', function () { $getTaxCalculations(' + id + ',function(){});})" disabled="disabled" ></select></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtCGST_' + id + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" value="' + Data[0].CGSTPercent + '" disabled="disabled"  /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtSGST_' + id + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});"  value="' + Data[0].SGSTPercent + '" disabled="disabled"  /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtIGST_' + id + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});"  value="' + Data[0].IGSTPercent + '" disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtDiscPer_' + id + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtDiscAmt_' + id + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtSpclDiscPer_' + id + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtSpclDiscAmt_' + id + '" maxlength="5" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" disabled="disabled" /></td>');

                //Asset GRN

              
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtAssetTagNo_' + id + '" onkeypress="return checkForSecondDecimal(this,event);" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtInstallationDate_' + id + '" class="requiredField"   /></td>');
               
                //Asset GRN End
                $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtQty_' + id + '" maxlength="10" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" value="' + ReturnQTY + '"  disabled="disabled" /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtFree_ServiceFrom_' + id + '" class="requiredField"   /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtFree_ServiceTo_' + id + '"   class="requiredField"   /></td>');

                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyNo_' + id + '"     class="requiredField"   /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyFrom_' + id + '"     tabindex="' + (id * 100 + 26) + '" class="requiredField"         /></td>');
                $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyTo_' + id + '"     tabindex="' + (id * 100 + 27) + '" class="requiredField"         /></td>');


                $('#tr_' + id).append('<td class="GridViewItemStyle"  style="display:none;"><input type="text" id="txtExp_' + id + '" maxlength="5"  value="' + Data[0].ExpDate + '" disabled="disabled" style="display:none;" /></td>');
               
                
                $('#tr_' + id).append('<td style="display:none;"><span id="spnItemName_' + id + '" >' + Data[0].ItemName + '</span><span id="spnItemId_' + id + '" >' + Data[0].ItemID + '</span><span id="spnIsExpirable_' + id + '">' + Data[0].IsExpirable + '</span><span id="spnSubCategoryID_' + id + '">' + Data[0].SubCategoryID + '</span><span id="spnIsUpdateCF_' + id + '">0</span> <span id="spnIsUpdateHSNCode_' + id + '">0</span><span id="spnIsUpdateGST_' + id + '">0</span><span id="spnIsUpdateExpirable_' + id + '">0</span></td>');
                $('#tr_' + id).append('<td style="display:none;"><span id="spnCGSTAmt_' + id + '">' + (parseFloat(Data[0].CGSTAmtPerUnit) * ReturnQTY) + '</span><span id="spnSGSTAmt_' + id + '">' + (parseFloat(Data[0].SGSTAmtPerUnit) * ReturnQTY) + '</span><span id="spnIGSTAmt_' + id + '">' + (parseFloat(Data[0].IGSTAmtPerUnit) * ReturnQTY) + '</span><span id="spnNetAmount_' + id + '">' + (parseFloat(Data[0].unitPrice) * ReturnQTY) + '</span><span id="spnDiscPer_' + id + '">0</span><span id="spnDiscAmt_' + id + '">0</span><span id="spnSpclDiscPer_' + id + '">0</span><span id="spnSpclDiscAmt_' + id + '">0</span><span id="spnGrossAmt_' + id + '">' + (parseFloat(Data[0].PurRate) * ReturnQTY) + '</span><span id="spnUnitPrice_' + id + '">' + (parseFloat(Data[0].unitPrice) * ReturnQTY) + '</span><span id="spnStockId_' + id + '">' + Data[0].StockID + '</span><span id="spnIsReturn_' + id + '">1</span><span id="spnGRNNo_' + id + '">' + Data[0].LedgerTransactionNo + '</span><span id="spnInvoiceNo_' + id + '">' + Data[0].InvoiceNo + '</span></td>');
                $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateAD").text("RateAD"));
                $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "Rate").text("Rate"));
                $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateRev").text("Rate Rev."));
                $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateExcl").text("Rate Excl."));
                $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "MRP").text("MRP"));
                $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "MRPExcl").text("MRP Excl."));
                $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "ExciseAmt").text("Excise Amt."));
                $bindGSTType(id, function () {
                    if (Data[0].GSTType == "IGST")
                        $('#ddlGSTType_' + id).val("T4");
                    else if (Data[0].GSTType == "CGST&UTGST")
                        $('#ddlGSTType_' + id).val("T7");
                    else
                        $('#ddlGSTType_' + id).val("T6");
                });
                $('#txtReturnQty').val('');
                $("#ddlReturnItems option[value='" + Data[0].StockID + "']").remove();
                $updateCount(id, function () { });
                callback(true);
            }
            else {
                $('#lblErrorReturn').text('Return QTY cannot be Greater than Avl Qty');
                $('#txtReturnQty').focus();
            }
        }
        $validateControls = function () {
            if ($('#ddlVendor').val() == "0") {
                modelAlert('Please Select Vendor');
                return false;
            }
            if ($('#ddlGRNType').val() == "0" || $('#ddlGRNType').val() == "3") {
                if ($('#txtBillNo').val() == "") {
                    modelAlert('Please Enter Invoice No.');
                    return false;
                }
                if ($('#txtBillDate').val() == "") {
                    modelAlert('Please Select Invoice Date');
                    return false;
                }
            }
            if ($('#ddlGRNType').val() == "1" || $('#ddlGRNType').val() == "3") {

                if ($('#txtChallanNo').val() == "") {
                    modelAlert('Please Enter Challan No.');
                    return false;
                }
                if ($('#txtChallanDate').val() == "") {
                    modelAlert('Please Select Challan Date');
                    return false;
                }
            }

            return true;

        }
        $disableControls = function () {
            $('#ddlVendor').chosen("destroy");
            $('#ddlVendor,#ddlGRNType,#txtBillNo,#txtBillDate,#txtChallanNo,#txtChallanDate,#txtWayBillNo,#txtWayBillDate,#txtGatePassInWard,#txtPurDate').attr('disabled', 'disabled');
            $('#rdoGRNPayType').find('input').prop('disabled', true);
        }
        $enableControls = function () {
            $('#ddlVendor,#ddlGRNType,#txtBillNo,#txtBillDate,#txtChallanNo,#txtChallanDate,#txtWayBillNo,#txtWayBillDate,#txtGatePassInWard,#txtPurDate').removeAttr('disabled');
            $('#ddlVendor').chosen();
            $('#rdoGRNPayType').find('input').prop('disabled', false);
            $('#ddlGRNType').change();
        }
        $validateData = function () {
            $con = 0;
            $('#tb_ItemsList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('id').split('_')[1];
                if ($('#spnIsFree_' + $rowid).text() == "1")
                    $(this).css("background-color", "aqua");
                else
                    $(this).css("background-color", "");
            });
            $('#tb_ItemsList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('id').split('_')[1];
                if ($('#spnItemName_' + $rowid).text() == "" || $('#spnItemId_' + $rowid).text() == "") {
                    modelAlert("Please Select Any Item At Row No.:" + $rowid);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }

                if (($('#txtRate_' + $rowid).val() == "" && $('#ddlGRNType').val() != "1") || (parseFloat($('#txtRate_' + $rowid).val()) < 1) && $('#ddlGRNType').val() != "1") {
                    modelAlert("Please Enter a Valid Rate At Row No.:" + $rowid);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if (($('#txtMrp_' + $rowid).val() == "" && $('#rblStoreType').find(':checked').val() == "STO00001") || (parseFloat($('#txtMrp_' + $rowid).val()) < 1) && $('#rblStoreType').find(':checked').val() == "STO00001") {
                    modelAlert("Please Enter a Valid MRP At Row No.:" + $rowid);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                else if ($('#txtMrp_' + $rowid).val() != "" && (parseFloat(($('#txtMrp_' + $rowid).val())) < parseFloat($('#txtRate_' + $rowid).val()))) {
                    modelAlert("Rate cannot be Greater Than MRP At Row No.:" + $rowid);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;

                }
                else if ($('#txtMrp_' + $rowid).val() != "" && (parseFloat(($('#txtMrp_' + $rowid).val())) < parseFloat($('#spnUnitPrice_' + $rowid).text()))) {
                 //   modelAlert("Unit Price cannot be Greater Than MRP At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
              //      $con = 1;
              //      return false;

                }


                if ($('#txtQty_' + $rowid).val() == "" || parseFloat($('#txtQty_' + $rowid).val()) < 1) {
                    modelAlert("Please Enter a Valid QTY At Row No.:" + $rowid);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtBatchNo_' + $rowid).val() == "" && $('#rblStoreType').find(':checked').val() == "STO00001") {
                    modelAlert("Please Enter Batch No. At Row No.:" + $rowid);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if (($('#txtExp_' + $rowid).val() == "" && $('#spnIsExpirable_' + $rowid).text() == "1") || ($('#spnIsExpirable_' + $rowid).text() == "1" && $('#txtExp_' + $rowid).val().length < 5)) {
                    modelAlert("Please Enter a Valid Expiry Date At Row No.:" + $rowid);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
               
                //if ($('#txtModelNo_' + $rowid).val() == "") {
                //    modelAlert("Please Enter a Model No At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtAssetTagNo_' + $rowid).val() == "") {
                //    modelAlert("Please Enter a Asset Tag No At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}  
                //if ($('#txtInstallationDate_' + $rowid).val() == "") {
                //    modelAlert("Please Select Installation Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtSerialNo_' + $rowid).val() == "") {
                //    modelAlert("Please Enter a Serial No At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //} 
                //if ($('#txtFree_ServiceFrom_' + $rowid).val() == "") {
                //    modelAlert("Please Select Free Service From Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtFree_ServiceTo_' + $rowid).val() == "") {
                //    modelAlert("Please Select Free Service To Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtFree_ServiceFrom_' + $rowid).val() > $('#txtFree_ServiceTo_' + $rowid).val()) {
                //    modelAlert("Free Service Date can not be less than Free Service To Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtWarrantyNo_' + $rowid).val() == "") {
                //    modelAlert("Please Enter Warranty No At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtWarrantyFrom_' + $rowid).val() == "") {
                //    modelAlert("Please Select Warranty From Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtWarrantyTo_' + $rowid).val() == "") {
                //    modelAlert("Please Select Warranty To Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtWarrantyFrom_' + $rowid).val() > $('#txtWarrantyTo_' + $rowid).val()) {
                //    modelAlert("Warranty Date can not be less than Warranty To Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                //if ($('#txtFree_ServiceTo_' + $rowid).val() > $('#txtWarrantyTo_' + $rowid).val()) {
                //    modelAlert("Free Service From Date can not be less than Warranty To Date At Row No.:" + $rowid);
                //    $(this).css("background-color", "#f54949");
                //    $con = 1;
                //    return false;
                //}
                if ($validateSerialNo($rowid, $('#spnItemId_' + $rowid).text(), $('#txtSerialNo_' + $rowid).val()) == "0") {
                    $con = 1;
                    return false;
                }

              
            });
            if ($('#txtNarration').val() == "" && $con == 0) {
                modelAlert("Please Enter Narration");
                $con = 1;

            }
            return $con;
        }
        $validateSerialNo= function ($rowid, $itemId, $SerialNo) {
            $dup = "1";
            $('#tb_ItemsList tbody tr:not(#tr_' + $rowid + ')').each(function () {
                $newRowid = $(this).closest('tr').attr('id').split('_')[1];
                if (($('#txtSerialNo_' + $newRowid).val() == $SerialNo) && ($('#spnItemId_' + $newRowid).text() == $itemId)) {
                    modelAlert("Serial No can not be duplicate with Same Item At Row No.:" + $newRowid);
                    $("#tr_" + $rowid + ",#tr_" + $newRowid).css("background-color", "lightpink");
                    $dup = "0";
                    return false;
                }

            });
            return $dup;
        }
        $validateDuplicateItem = function ($rowid, $itemId, $batchNo, $isFree) {
            $dup = "1";
            $('#tb_ItemsList tbody tr:not(#tr_' + $rowid + ')').each(function () {
                $newRowid = $(this).closest('tr').attr('id').split('_')[1];
                if (($('#txtBatchNo_' + $newRowid).val() == $batchNo) && ($('#spnItemId_' + $newRowid).text() == $itemId) && ($('#spnIsFree_' + $newRowid).text() == $isFree) && ($('#spnIsReturn_' + $newRowid).text() == "0")) {
                    modelAlert("Duplicate Items Exists with Same Batch and Free Condition");
                    $("#tr_" + $rowid + ",#tr_" + $newRowid).css("background-color", "lightpink");
                    $dup = "0";
                    return false;
                }

            });
            return $dup;
        }
        $checkDuplicateInvoice = function (callback) {
            serverCall('Services/WebService.asmx/checkDuplicateInvoice', { VendorLedgerNo: $('#ddlVendor').val().split('#')[0], InvoiceNo: $('#txtBillNo').val(), ChallanNo: $('#txtChallanNo').val(), Type: $('#ddlGRNType option:selected').text() }, function (response) {
                if (response == "1") {
                    modelAlert('Invoice No. Already Exist');
                    callback(true);
                }
                if (response == "2") {
                    modelAlert('Challan No. Already Exist');
                    callback(true);
                }
                if (response == "0") {
                    callback(false);
                }
            });

        }
        $SaveGRN = function (btn, callback) {

            if ($validateData() == "0") {
                $(btn).attr('disabled', 'disabled');
                $getInvoiceData(function ($InvoiceData) {
                    $getItemDetails(function ($ItemData) {
                        serverCall('Services/WebService.asmx/SaveGRN', { InvoiceData: $InvoiceData, ItemDetails: $ItemData }, function (Response) {
                            if (Response != "") {
                                modelAlert("GRN No. " + Response.split('#')[1]);
                                if ($('#rblStoreType').find(':checked').val() == "STO00001")
                                    window.open('DirectGRNReport.aspx?Hos_GRN=' + Response.split('#')[0]);
                                else
                                    window.open('DirectGRNReport.aspx?Proj_GRN=' + Response.split('#')[0]);
                                $clear();
                            }
                            else {
                                modelAlert("Error Occured...");
                            }

                        });
                    });
                });
            }
            $(btn).removeAttr('disabled');
            callback(true);
        }
        $getInvoiceData = function (callback) {
            $data = new Array();
            $data.push({
                VenLedgerNo: $('#ddlVendor').val().split('#')[0],
                InvoiceNo: $('#txtBillNo').val(),
                InvoiceDate: $('#txtBillDate').val(),
                ChalanNo: $('#txtChallanNo').val(),
                ChalanDate: $('#txtChallanDate').val(),
                WayBillNo: $('#txtWayBillNo').val(),
                WayBillDate: $('#txtWayBillDate').val(),
                GatePassIn: $('#txtGatePassInWard').val(),
                //GrossBillAmount: $('#txtBillGrossAmt').val(),
                NetAmount: $('#txtInvoiceAmount').val(),
                RoundOff: $('#txtRoundOff').val(),
                DiscAmount: $('#txtTotalItemWiseDisc').val(),
                StoreLedgerNo: $('#rblStoreType').find(':checked').val(),
                PaymentModeID: $('#rdoGRNPayType').find(':checked').val(),
                FrieghtCharges: $('#txtFrieghtCharges').val()
            });
            callback($data);
        }
        $getItemDetails = function (callback) {
            $data = new Array();
            $('#tb_ItemsList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('id').split('_')[1];
                $IsFree = 0;
                if ($('#spnIsFree_' + $rowid).text() == "1")
                    $IsFree = 1;
                $cgstPer = 0;
                $sgstPer = 0;
                $igstPer = 0;
                $mrp = 0;
                if ($('#txtCGST_' + $rowid).val() != "")
                    $cgstPer = parseFloat($.trim($('#txtCGST_' + $rowid).val()));
                if ($('#txtSGST_' + $rowid).val() != "")
                    $sgstPer = parseFloat($.trim($('#txtSGST_' + $rowid).val()));
                if ($('#txtIGST_' + $rowid).val() != "")
                    $igstPer = parseFloat($.trim($('#txtIGST_' + $rowid).val()));

                $cgstAmt = parseFloat($('#spnCGSTAmt_' + $rowid).text());
                $sgstAmt = parseFloat($('#spnSGSTAmt_' + $rowid).text());
                $igstAmt = parseFloat($('#spnIGSTAmt_' + $rowid).text());
                if ($('#txtMrp_' + $rowid).val() != "")
                    $mrp = $('#txtMrp_' + $rowid).val();
                //$isDeal = '';
                //if ($('#txtDeal1_' + $rowid).val() != '' && $('#txtDeal2_' + $rowid).val() != '') {
                //    $isDeal = ($('#txtDeal1_' + $rowid).val() + "+" + $('#txtDeal2_' + $rowid).val());
                //}
                $IsUpdateItemMaster = 0;
                if ($('#cbIsUpdateMaster_' + $rowid).prop('checked') == true)
                    $IsUpdateItemMaster = 1;
                if ($('#spnIsExpirable_' + $rowid).text() == "1")
                    $ExpiryDate = $('#txtExp_' + $rowid).val().split('/')[0] + '/01/20' + $('#txtExp_' + $rowid).val().split('/')[1];
                else
                    $ExpiryDate = '01/01/0001';
                $data.push({
                    DeptLedgerNo: ('<%= ViewState["DeptLedgerNo"].ToString()%>'),
                    StockID: $('#spnStockId_' + $rowid).text(),
                    ItemID: $('#spnItemId_' + $rowid).text(),
                    ItemName: $('#txtItemName_' + $rowid).val(),
                    BatchNumber: $('#txtBatchNo_' + $rowid).val(),
                    UnitPrice: $('#spnUnitPrice_' + $rowid).text(),
                    MRP: $mrp,
                    Quantity: $('#txtQty_' + $rowid).val(),
                    IsReturn: $('#spnIsReturn_' + $rowid).text(),
                    MedExpiryDate: $ExpiryDate,
                    StoreLedgerNo: $('#rblStoreType').find(':checked').val(),
                    Naration: $('#txtNarration').val(),
                    IsFree: $IsFree,
                    SubCategoryID: $('#spnSubCategoryID_' + $rowid).text(),
                    Rate: $('#txtRate_' + $rowid).val(),
                    DiscPer: $('#spnDiscPer_' + $rowid).text(),
                    DiscAmt: $('#spnDiscAmt_' + $rowid).text(),
                    PurTaxPer: parseFloat($cgstPer + $sgstPer + $igstPer),
                    PurTaxAmt: parseFloat($cgstAmt + $sgstAmt + $igstAmt),
                    MajorUnit: $('#spnPurUnit_' + $rowid).text(),
                    MinorUnit: $('#spnSalesUnit_' + $rowid).text(),
                    MajorMRP: $mrp,
                    InvoiceNo: $('#txtBillNo').val(),
                    ChalanNo: $('#txtChallanNo').val(),
                    InvoiceDate: $('#txtBillDate').val(),
                    ChalanDate: $('#txtChallanDate').val(),
                    VenLedgerNo: $('#ddlVendor').val().split('#')[0],
                    InvoiceAmount: $('#txtInvoiceAmount').val(),
                    IsExpirable: $('#spnIsExpirable_' + $rowid).text(),
                    HSNCode: $('#txtHSNCode_' + $rowid).val(),
                    GSTType: $('#ddlGSTType_' + $rowid + ' option:selected').text(),
                    IGSTPercent: $igstPer,
                    CGSTPercent: $cgstPer,
                    SGSTPercent: $sgstPer,
                    IGSTAmt: $igstAmt,
                    CGSTAmt: $cgstAmt,
                    SGSTAmt: $sgstAmt,
                    SpecialDiscPer: $('#spnSpclDiscPer_' + $rowid).text(),
                    SpecialDiscAmt: $('#spnSpclDiscAmt_' + $rowid).text(),
                    RetrunFromGRN: $('#spnGRNNo_' + $rowid).text(),
                    RetrunFromInvoiceNo: $('#spnInvoiceNo_' + $rowid).text(),
                    ItemGrossAmount: $('#spnGrossAmt_' + $rowid).text(),
                    ItemNetAmount: $('#spnNetAmount_' + $rowid).text(),
                    IsUpdateCF: $('#spnIsUpdateCF_' + $rowid).text(),
                    IsUpdateHSNCode: $('#spnIsUpdateHSNCode_' + $rowid).text(),
                    IsUpdateGST: $('#spnIsUpdateGST_' + $rowid).text(),
                    IsUpdateExpirable: $('#spnIsUpdateExpirable_' + $rowid).text(),

                    // Asset 
                    AssetPurDate: $('#txtPurDate').val(),
                    SerialNo: $('#txtSerialNo_' + $rowid).val(),
                    ModelNo: $('#txtModelNo_' + $rowid).val(),
                    AssetTagNo: $('#txtAssetTagNo_' + $rowid).val(),
                    InstDate: $('#txtInstallationDate_' + $rowid).val(),
                    ServiceFrom: $('#txtFree_ServiceFrom_' + $rowid).val(),
                    ServiceTo: $('#txtFree_ServiceTo_' + $rowid).val(),
                    WarrantyNo: $('#txtWarrantyNo_' + $rowid).val(),
                    WarrantyFrom: $('#txtWarrantyFrom_' + $rowid).val(),
                    WarrantyTo: $('#txtWarrantyTo_' + $rowid).val(),


                    //Asset End

                });
            });
            callback($data);

        }
        $clear = function () {
            location.reload();
        }
        $UpdateMaster = function (id, callback) {

            if ($('#spnItemId_' + id).text() == "") {
                modelAlert('Please Select Item First');
                return false;
            }
            else {
                $('#cbUpdateCF,#cbUpdateHSNCode,#cbUpdateGSTType,#cbUpDateIsExpirable').attr('checked', 'checked');
                $('#ddlUpdateGSTType').empty();
                serverCall('Services/WebService.asmx/bindGSTType', callback, function (response) {
                    var Data = $.parseJSON(response);
                    for (var i = 0; i < Data.length; i++) {
                        $('#ddlUpdateGSTType').append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                    }
                    $('#lblUpdateItemName').text($('#spnItemName_' + id).text());
                    $('#spnUpdateRowId').text(id);
                    $('#txtUpdateHSNCode').val($('#txtHSNCode_' + id).val());
                    if ($('#ddlGSTType_' + id).val() == "T4") {
                        $('#ddlUpdateGSTType').val("T4");
                        $('#txtUpdateIGSTPer').removeAttr('disabled');
                        $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').attr('disabled', 'disabled');
                    }
                    else if ($('#ddlGSTType_' + id).val() == "T7") {
                        $('#ddlUpdateGSTType').val("T7");
                        $('#txtUpdateIGSTPer').attr('disabled', 'disabled');
                        $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');

                    }
                    else {
                        $('#ddlUpdateGSTType').val("T6");
                        $('#txtUpdateIGSTPer').attr('disabled', 'disabled');
                        $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');
                    }
                    $('#txtUpdateIGSTPer').val($('#txtIGST_' + id).val());
                    $('#txtUpdateCGSTPer').val($('#txtCGST_' + id).val());
                    $('#txtUpdateSGSTPer').val($('#txtSGST_' + id).val());
                    if ($('#spnIsExpirable_' + id).text() == "1")
                        $('#cbUpDateIsExpirableValue').attr('checked', 'checked');
                    else
                        $('#cbUpDateIsExpirableValue').removeAttr('checked');
                    $('#divUpdateItemMaster').showModel();
                    callback(true);
                });
            }
            callback(true);
        }
        $changeUpdateGSTType = function () {
            if ($('#ddlUpdateGSTType').val() == "T4") {
                $('#txtUpdateIGSTPer').removeAttr('disabled');
                $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').attr('disabled', 'disabled');
            }
            else if ($('#ddlUpdateGSTType').val() == "T7") {
                $('#txtUpdateIGSTPer').attr('disabled', 'disabled');
                $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');

            }
            else {
                $('#txtUpdateIGSTPer').attr('disabled', 'disabled');
                $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');
            }
            $('#txtUpdateIGSTPer,#txtUpdateCGSTPer,#txtUpdateSGSTPer').val('0.0000');

        }
        $BindUpdates = function () {
            $rowId = $('#spnUpdateRowId').text();
            $('#spnIsUpdateCF_' + $rowId + ',#spnIsUpdateHSNCode_' + $rowId + ',#spnIsUpdateGST_' + $rowId + ',#spnIsUpdateExpirable_' + $rowId).text('0');
            $CF = 1;
            $CGSTPer = 0.0000;
            $SGSTPer = 0.0000;
            $IGSTPer = 0.0000;
            if ($('#txtUpdateCF').val() != "")
                $CF = parseFloat($('#txtUpdateCF').val());
            if ($('#txtUpdateCGSTPer').val() != "")
                $CGSTPer = parseFloat($('#txtUpdateCGSTPer').val());
            if ($('#txtUpdateSGSTPer').val() != "")
                $SGSTPer = parseFloat($('#txtUpdateSGSTPer').val());
            if ($('#txtUpdateIGSTPer').val() != "")
                $IGSTPer = parseFloat($('#txtUpdateIGSTPer').val());

            if ($('#cbUpdateHSNCode').prop('checked') == true) {
                $('#txtHSNCode_' + $rowId).val($('#txtUpdateHSNCode').val());
                $('#spnIsUpdateHSNCode_' + $rowId).text('1');
            }
            if ($('#cbUpdateGSTType').prop('checked') == true) {
                $('#spnIsUpdateGST_' + $rowId).text('1');
                $('#ddlGSTType_' + $rowId).val($('#ddlUpdateGSTType').val());
                $('#txtCGST_' + $rowId).val($('#txtUpdateCGSTPer').val());
                $('#txtSGST_' + $rowId).val($('#txtUpdateSGSTPer').val());
                $('#txtIGST_' + $rowId).val($('#txtUpdateIGSTPer').val());
                if ($('#ddlUpdateGSTType').val() == "T4") {
                    $('#txtIGST_' + $rowId).removeAttr('disabled');
                    $('#txtCGST_' + $rowId + ',#txtSGST_' + $rowId).attr('disabled', 'disabled');
                }
                else if ($('#ddlUpdateGSTType').val() == "T7") {
                    $('#txtIGST_' + $rowId).attr('disabled', 'disabled');
                    $('#txtCGST_' + $rowId + ',#txtSGST_' + $rowId).removeAttr('disabled');

                }
                else {
                    $('#txtIGST_' + $rowId).attr('disabled', 'disabled');
                    $('#txtCGST_' + $rowId + ',#txtSGST_' + $rowId).removeAttr('disabled');
                }

            }
            if ($('#cbUpDateIsExpirable').prop('checked') == true) {
                $('#spnIsUpdateExpirable_' + $rowId).text('1');
                if ($('#cbUpDateIsExpirableValue').prop('checked') == true) {
                    $('#txtExp_' + $rowId).val('').removeAttr('disabled');
                    $('#spnIsExpirable_' + $rowId).text('1');

                }
                else {
                    $('#txtExp_' + $rowId).val('').attr('disabled', 'disabled');
                    $('#spnIsExpirable_' + $rowId).text('0');

                }
            }
            $('#divUpdateItemMaster').hide();
        }
        $(function () {
            shortcut.add('Alt+S', function () {
                var btnSave = $('#btnSaveGRN');
                if (btnSave.length > 0) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        $SaveGRN(btnSave, function () { });
                    }
                }
            }, addShortCutOptions);
            shortcut.add('Enter', function () {
                var focused = document.activeElement;
                if ($(focused).attr('id').split('_').length > 0) {
                    if ($(focused).attr('id').split('_')[0] == "txtExp") {
                        $newId = (parseInt($('#tb_ItemsList tbody tr:last').attr('id').split('_')[1]) + 1)
                        $addNewRow($newId, 0, function () {
                            $updateCount($newId, function () { });
                        });
                    }
                    else {
                        $CurrentIndex = $(focused).attr('tabindex');
                        $NextIndex = $checkNextActiveIndex($CurrentIndex, $CurrentIndex);
                        $('[tabindex=' + $NextIndex + ']').focus();
                    }
                }
                else {
                    $CurrentIndex = $(focused).attr('tabindex');
                    $NextIndex = $checkNextActiveIndex($CurrentIndex, $CurrentIndex);
                    $('[tabindex=' + $NextIndex + ']').focus();
                }

            }, addShortCutOptions);
        });
        $checkNextActiveIndex = function (currentIndex, startIndex) {
            if ((currentIndex - startIndex) > 20)
                return currentIndex + 1;
            if ($('[tabindex=' + (currentIndex + 1) + ']').attr('disabled') == "disabled") {
                return ($checkNextActiveIndex((currentIndex + 1), startIndex));
            }
            else {
                if ($('[tabindex=' + (currentIndex + 1) + ']').length == 0)
                    return ($checkNextActiveIndex((currentIndex + 1), startIndex));
                else
                    return ((currentIndex + 1));
            }

        }
        $('#ddlVendor').change(function () {
            $('[tabindex="3"]').focus();
        });
        $('#divItemsList').slimScroll({
            height: '280px',
        });


        // Asset GRN

        $AddQtyItems = function (id, IsFree, callback) {
            $isRequiredClass = "";
            if ($('#rblStoreType').find(':checked').val() == "STO00001")
                $isRequiredClass = "requiredField";
            $('#tb_ItemsList tbody').append('<tr id="tr_' + id + '"></tr>')
            $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnAddFree_' + id + '" src="../../Images/plus_blue.png" onclick="$addNewRow(' + (id + 1) + ',1,function(){})" style="cursor:pointer;" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnAdd_' + id + '" src="../../Images/plus_in.gif" onclick="$addNewRow(' + (id + 1) + ',0,function(){})" style="cursor:pointer;" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><img id="btnRemove_' + id + '" src="../../Images/Delete.gif" onclick="$removeRow(this,function(){})" style="cursor:pointer;" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"  style="display:none;" align="center"><img src="../../Images/Post.gif" style="cursor:pointer;" onclick="$UpdateMaster(' + id + ',function(){})" /> </td>');


            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtItemName_' + id + '" tabindex="' + (id * 100 + 1) + '" class="requiredField" autocomplete="off" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><span id="spnPurUnit_' + id + '"></span></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><span id="spnSalesUnit_' + id + '"></span></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtHSNCode_' + id + '" tabindex="' + (id * 100 + 3) + '"  maxlength="10" autocomplete="off" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><select id="ddlTaxCalOn_' + id + '"  tabindex="' + (id * 100 + 4) + '" onchange="$getTaxCalculations(' + id + ',function(){});" ></select></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtRate_' + id + '"  tabindex="' + (id * 100 + 7) + '" maxlength="10" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtMrp_' + id + '" maxlength="10" tabindex="' + (id * 100 + 8) + '" class="' + $isRequiredClass + '" onkeypress="return checkForSecondDecimal(this,event);"   /></td>');

            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtBatchNo_' + id + '" maxlength="10" tabindex="' + (id * 100 + 10) + '" class="' + $isRequiredClass + '" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtModelNo_' + id + '" tabindex="' + (id * 100 + 18) + '"  onkeypress="return checkForSecondDecimal(this,event);" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtSerialNo_' + id + '" tabindex="' + (id * 100 + 22) + '" onkeypress="return checkForSecondDecimal(this,event);"  /></td>');

            $('#tr_' + id).append('<td class="GridViewItemStyle"><select id="ddlGSTType_' + id + '" tabindex="' + (id * 100 + 11) + '" onchange=" $changeTaxType(' + id + ', function () { $getTaxCalculations(' + id + ',function(){});})" >' + $('#ddlGSTType_' + (id - 1)).html() + '</select></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtCGST_' + id + '" tabindex="' + (id * 100 + 12) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});"  disabled="disabled" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtSGST_' + id + '" tabindex="' + (id * 100 + 13) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});"  disabled="disabled" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtIGST_' + id + '" tabindex="' + (id * 100 + 14) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});"  disabled="disabled" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtDiscPer_' + id + '" tabindex="' + (id * 100 + 15) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtDiscAmt_' + id + '" tabindex="' + (id * 100 + 16) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtSpclDiscPer_' + id + '" tabindex="' + (id * 100 + 17) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');
            $('#tr_' + id).append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtSpclDiscAmt_' + id + '"  maxlength="5" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});" onkeyup="$ValidateDiscount(' + id + ',function(){});" /></td>');

            //Asset GRN

           
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtAssetTagNo_' + id + '" tabindex="' + (id * 100 + 19) + '" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtInstallationDate_' + id + '" tabindex="' + (id * 100 + 20) + '" class="requiredField"   /></td>');
          
            //$('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtServiceFrom_' + id + '" tabindex="' + (id * 100 + 21) + '" class="requiredField"   /></td>');
            //$('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtServiceTo_' + id + '"   tabindex="' + (id * 100 + 22) + '"  class="requiredField"   /></td>');


            //Asset GRN End
            $('#tr_' + id).append('<td class="GridViewItemStyle"><input type="text" id="txtQty_' + id + '" value="1" maxlength="10" class="requiredField" tabindex="' + (id * 100 + 21) + '" onkeypress="return checkForSecondDecimal(this,event);"  onblur="$getTaxCalculations(' + id + ',function(){});"  disabled="disabled" /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtFree_ServiceFrom_' + id + '" tabindex="' + (id * 100 + 23) + '" class="requiredField"   /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtFree_ServiceTo_' + id + '"   tabindex="' + (id * 100 + 24) + '"  class="requiredField"   /></td>');

            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyNo_' + id + '"       tabindex="' + (id * 100 + 25) + '" class="requiredField"   /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyFrom_' + id + '"     tabindex="' + (id * 100 + 26) + '" class="requiredField"         /></td>');
            $('#tr_' + id).append('<td class="GridViewItemStyle" style="display:none;"><input type="text" id="txtWarrantyTo_' + id + '"     tabindex="' + (id * 100 + 27) + '" class="requiredField"         /></td>');


            $('#tr_' + id).append('<td class="GridViewItemStyle"  style="display:none;"><input type="text" id="txtExp_' + id + '" maxlength="5" placeholder="mm/YY" tabindex="' + (id * 100 + 28) + '" onkeypress="return validateCharacter(this,event,' + id + ');" onkeyup="return validateExpiry(this,event);" ToolTip="Press Enter to Add New Row" disabled="disabled" /></td>');
       
            
            $('#tr_' + id).append('<td style="display:none;"><span id="spnItemName_' + id + '" ></span><span id="spnItemId_' + id + '" ></span><span id="spnIsExpirable_' + id + '"></span><span id="spnSubCategoryID_' + id + '"></span><span id="spnIsUpdateCF_' + id + '">0</span> <span id="spnIsUpdateHSNCode_' + id + '">0</span><span id="spnIsUpdateGST_' + id + '">0</span><span id="spnIsUpdateExpirable_' + id + '">0</span></td>');
            $('#tr_' + id).append('<td style="display:none;"><span id="spnCGSTAmt_' + id + '">0</span><span id="spnSGSTAmt_' + id + '">0</span><span id="spnIGSTAmt_' + id + '">0</span><span id="spnNetAmount_' + id + '">0</span><span id="spnDiscPer_' + id + '">0</span><span id="spnDiscAmt_' + id + '">0</span><span id="spnSpclDiscPer_' + id + '">0</span><span id="spnSpclDiscAmt_' + id + '">0</span><span id="spnGrossAmt_' + id + '">0</span><span id="spnUnitPrice_' + id + '">0</span><span id="spnStockId_' + id + '"></span><span id="spnIsReturn_' + id + '">0</span><span id="spnGRNNo_' + id + '"></span><span id="spnInvoiceNo_' + id + '"></span><span id="spnIsFree_' + id + '">' + IsFree + '</span><span id="spnIsOnSellingPrice' + id + '">0</span><span id="spnSellingMargin' + id + '">0.00</span></td>');

            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateAD").text("RateAD"));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "Rate").text("Rate"));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateRev").text("Rate Rev."));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "RateExcl").text("Rate Excl."));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "MRP").text("MRP"));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "MRPExcl").text("MRP Excl."));
            $('#ddlTaxCalOn_' + id).append($("<option></option>").attr("value", "ExciseAmt").text("Excise Amt."));

          //  $bindGSTType(id, function () {
              
                $setDuplicateRow(id, function () { });
              //  $changeTaxType(id, function () { });
          //  });
      
               

            callback(true);
        }

        $setDuplicateRow = function (id, callback) {
            $('#txtItemName_' + id).val($('#txtItemName_' + (id - 1)).val());
            $('#spnPurUnit_' + id).text($('#spnPurUnit_' + (id - 1)).text());
            $('#spnSalesUnit_' + id).text($('#spnSalesUnit_' + (id - 1)).text());
            $('#txtHSNCode_' + id).val($('#txtHSNCode_' + (id - 1)).val());
            $('#ddlTaxCalOn_' + id).val($('#ddlTaxCalOn_' + (id - 1)).val());
            $('#txtRate_' + id).val($('#txtRate_' + (id - 1)).val());
            $('#txtMrp_' + id).val($('#txtMrp_' + (id - 1)).val());
            $('#txtBatchNo_' + id).val($('#txtBatchNo_' + (id - 1)).val());

            $('#ddlGSTType_' + id).val($('#ddlGSTType_' + (id - 1)).val());

            if ($('#ddlGSTType_' + id).val() == "T4") {
                $('#txtIGST_' + id).removeAttr('disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).attr('disabled', 'disabled');
            }
            else if ($('#ddlGSTType_' + id).val() == "T7") {
                $('#txtIGST_' + id).attr('disabled', 'disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).removeAttr('disabled');
            }
            else {
                $('#txtIGST_' + id).attr('disabled', 'disabled');
                $('#txtCGST_' + id + ',#txtSGST_' + id).removeAttr('disabled');
            }





            $('#txtCGST_' + id).val($('#txtCGST_' + (id - 1)).val());
            $('#txtSGST_' + id).val($('#txtSGST_' + (id - 1)).val());
            $('#txtIGST_' + id).val($('#txtIGST_' + (id - 1)).val());
            $('#txtDiscPer_' + id).val($('#txtDiscPer_' + (id - 1)).val());
            $('#txtDiscAmt_' + id).val($('#txtDiscAmt_' + (id - 1)).val());
            $('#txtSpclDiscPer_' + id).val($('#txtSpclDiscPer_' + (id - 1)).val());
            $('#txtSpclDiscAmt_' + id).val($('#txtSpclDiscAmt_' + (id - 1)).val());
            $('#txtExp_' + id).val($('#txtExp_' + (id - 1)).val());

            //Asset
            $('#txtModelNo_' + id).val($('#txtModelNo_' + (id - 1)).val());
            $('#txtAssetTagNo_' + id).val($('#txtAssetTagNo_' + (id - 1)).val());
            $('#txtInstallationDate_' + id).val($('#txtInstallationDate_' + (id - 1)).val());
            $('#txtFree_ServiceFrom_' + id).val($('#txtFree_ServiceFrom_' + (id - 1)).val());
            $('#txtFree_ServiceTo_' + id).val($('#txtFree_ServiceTo_' + (id - 1)).val());
            //$('#txtSerialNo_' + id).val($('#txtSerialNo_' + (id - 1)).val());
            //$('#txtWarrantyNo_' + id).val($('#txtWarrantyNo_' + (id - 1)).val());
            //$('#txtWarrantyFrom_' + id).val($('#txtWarrantyFrom_' + (id - 1)).val());
            //Asset End



            $('#spnItemName_' + id).text($('#spnItemName_' + (id - 1)).text());
            $('#spnItemId_' + id).text($('#spnItemId_' + (id - 1)).text());
            $('#spnIsExpirable_' + id).text($('#spnIsExpirable_' + (id - 1)).text());
            $('#spnSubCategoryID_' + id).text($('#spnSubCategoryID_' + (id - 1)).text());
            $('#spnIsUpdateCF_' + id).text('0');
            $('#spnIsUpdateHSNCode_' + id).text('0');
            $('#spnIsUpdateGST_' + id).text('0');
            $('#spnIsUpdateExpirable_' + id).text('0');
            $("#tr_" + id).css("background-color", "#e0fff6");
            $getTaxCalculations(id, function () { });
            callback(true);
        }


        //Asset GRN End


    </script>
</asp:Content>
