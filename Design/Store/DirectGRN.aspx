<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" MasterPageFile="~/DefaultHome.master"
    CodeFile="DirectGRN.aspx.cs" Inherits="Design_Store_DirectGRN" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

    <style type="text/css">
        #Pbody_box_inventory {
            width: 99.7% !important;
        }

        .POuter_Box_Inventory {
            width: 99.87% !important;
        }

        .ui-state-focus {
            /*background: none !important;*/
            background-color: #c6dff9 !important;
            border: none !important;
        }

        .ui-menu-item {
            width: 370px;
            max-width: 370px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .ui-widget-content {
            border-radius: 5px;
        }

        .freeItemRow {
            background-color: aqua !important;
        }
    </style>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" id="divPageName" style="text-align: center;">
            <b>Store GRN</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            <label class="hidden" id="lblLedgerTransactionNo"></label>
        </div>
        <asp:Panel ID="pnlPurchase" runat="server" Width="100%">
            <div class="POuter_Box_Inventory" id="divOrderDetails">
                <div class="Purchaseheader">
                    Order Detail
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Store Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="True" TabIndex="1" ClientIDMode="Static">
                                    <asp:ListItem Value="STO00001" >Medical Store</asp:ListItem>
                                    <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">
                                    Supplier
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlVendor" CssClass="requiredField" runat="server" TabIndex="2" ClientIDMode="Static">
                                </asp:DropDownList>
                            </div>
                            <%--<div class="col-md-3">
                                <label class="pull-left">
                                    WayBill No. & Date 
                                </label>
                                <b class="pull-right">:</b>
                            </div>--%>
                            <div class="col-md-5" style="display:none">
                                <asp:TextBox ID="txtWayBillNo" runat="server" onkeyup="CheckBillDate()" CssClass="requiredField" MaxLength="50" Width="58%" TabIndex="3" ClientIDMode="Static">
                                </asp:TextBox>
                                <asp:TextBox ID="txtWayBillDate" CssClass="requiredField" runat="server" Width="40%" TabIndex="4" ClientIDMode="Static">
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
                                <asp:DropDownList ID="ddlGRNType" runat="server" ClientIDMode="Static" TabIndex="5" onchange="ShowRequiredField()" >
                                    <asp:ListItem Text="Invoice" Value="0" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Delivery" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Delivery with Invoice" Value="3"></asp:ListItem>
                                </asp:DropDownList>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Invoice No.& Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBillNo"  runat="server"  MaxLength="50" Width="58%" TabIndex="6" ClientIDMode="Static"> </asp:TextBox>
                                <asp:TextBox ID="txtBillDate"  runat="server" Width="40%" TabIndex="7" ClientIDMode="Static"> </asp:TextBox>
                                <cc1:CalendarExtender ID="calBillDate" TargetControlID="txtBillDate" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                 Delivery No. & Date 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtChallanNo" runat="server" onkeyup="CheckBillDate()"  MaxLength="50" Width="58%" ClientIDMode="Static" TabIndex="8">
                                </asp:TextBox>
                                <asp:TextBox ID="txtChallanDate"  runat="server" Width="40%" ClientIDMode="Static" TabIndex="9"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalchallanDate" TargetControlID="txtChallanDate" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>

                        </div>
                        <div class="row">
                            <%--<div class="col-md-3">
                                <label class="pull-left">
                                    Gate Entry No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>--%>
                            <div class="col-md-5" style="display:none">
                                <asp:TextBox ID="txtGatePassInWard" runat="server" TabIndex="10" ClientIDMode="Static">
                                </asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    GRN Pay Mode
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdoGRNPayType" runat="server"
                                    RepeatColumns="2" RepeatDirection="Horizontal" TabIndex="11" ClientIDMode="Static">
                                    <asp:ListItem Selected="True" Text="Credit" Value="4"> </asp:ListItem>
                                    <asp:ListItem Text="Cash" Value="1"> </asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-3">
                                  <%if (Resources.Resource.IsGSTApplicable == "0")
                                    { %>
                                <label class="pull-left">
                                   Other Charges
                                </label>
                                <b class="pull-right">:</b>
                                 <%} %>
                            </div>
                            <div class="col-md-5">
                               
                                <input type="text" id="txtOtherCharges" onchange="onOtherChargesChange(this)" onlynumber="10" value="0" decimalplace="4" max-value="100000000" 
                                    
                                    <%if (Resources.Resource.IsGSTApplicable == "1")
                                      { %>
                                     style="width:58%; display:none;"
                                    <%}
                                      else
                                      { %>
                                     style="width:58%;"
                                    <%} %>
                                     
                                    />
                      
                                <input type="button" value="Purchase Order's" id="btnShowPO" style="width:40%" onclick="getPurchaseOrders(this, event)" />
                            </div> 
                            
                            
                            <div class="col-md-3 selectedPurchaseOrder hidden">
                                <label class="pull-left">
                                    <a href="javascript:void(0)" class=""> <b> Purchase Order</b></a>
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5 selectedPurchaseOrder hidden">
                                <label id="lblSelectedPurchaseOrder" class="patientInfo" style="font-weight:bold"></label>

                            </div>
                            
                             <div class="col-md-3 GRNEdit hidden">
                                <label class="pull-left">
                                    <a href="javascript:void(0)" class=""> <b>Edit GRN No.</b></a>
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5 GRNEdit hidden">
                                <label id="lblGRNNoPre" class="patientInfo" style="font-weight:bold"></label>

                            </div>



                        </div>

                         <div class="row" style="display:none;">
                            <div class="col-md-3">
                                <label class="pull-left">
                                   Consignment Rec.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rbtIsConsignment" runat="server" RepeatColumns="2" onchange="ShowPurchaseOrder()" RepeatDirection="Horizontal" TabIndex="12" ClientIDMode="Static">
                                    <asp:ListItem Selected="True" Text="No" Value="0"> </asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1"> </asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                </label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                 
                                </label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>

                        <div class="row" style="display: none;">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Tax On
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
                        <div class="row ItDoseLblError hidden">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Note
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21">
                               ALT+C : Delete Last Row, ALT+V : Add Free Item, ALT+B : Add Other Batch Item,ALT+N : Add New Item,ALT+S : Save GRN
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
                        <table id="tb_ItemsList" style="width: 100%; border-collapse: collapse; margin: 0; padding: 0;">
                            <thead style="width: 100%;">
                                <tr id="tHead">
                                    <th class="GridViewHeaderStyle" style="width: 200px">Item Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 45px">C.F.</th>
                                    <%--   <th class="GridViewHeaderStyle" style="width: 45px">Pur. Unit</th>
                                    <th class="GridViewHeaderStyle" style="width: 45px">Sales Unit</th>--%>
                                    <th class="GridViewHeaderStyle" style="width: 60px">Pur./Sales Unit</th>
                                    <%if (Resources.Resource.IsGSTApplicable == "1")
                                      { %>
                                    <th class="GridViewHeaderStyle" style="width: 60px">HSN Code</th>
                                    <%} %>
                                    <th class="GridViewHeaderStyle" style="width: 85px">Tax On</th>
                                    <%if (Resources.Resource.IsGSTApplicable == "1")
                                      { %>
                                    <th class="GridViewHeaderStyle" style="width: 90px;">Deal</th>
                                    <%} %>
                                    <th class="GridViewHeaderStyle" style="width: 80px">QTY</th>
                                    <th class="GridViewHeaderStyle" style="width: 90px">Rate</th>
                                     <th class="GridViewHeaderStyle" style="width: 120px">Batch</th>
                                    <th class="GridViewHeaderStyle" style="width: 90px;display:none">MRP</th>
                                   
                                    <th class="GridViewHeaderStyle" style="width: 40px">Disc (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px">Disc. Amt</th>
                                    <%if (Resources.Resource.IsGSTApplicable == "1")
                                      { %>
                                    <th class="GridViewHeaderStyle" style="width: 40px">Spcl Disc (%)</th>
                                    <% }%>
                                    <%if (Resources.Resource.IsGSTApplicable == "0")
                                      { %>
                                      <th class="GridViewHeaderStyle" style="width: 50px">VAT</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px">VAT Amt.</th>
                                     <% }
                                      else
                                      { %>
                                     <th class="GridViewHeaderStyle" style="width: 60px">GST Type</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px">CGST (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px">SGST/ UTGST (%)</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px">IGST (%)</th>
                                    <%} %>
                                    <%--<th class="GridViewHeaderStyle" style="width: 40px">Spcl Disc (%)</th>--%>
                                    <%--<th class="GridViewHeaderStyle" style="width: 50px;">Spcl Disc Amt</th>--%>

                                     <%if (Resources.Resource.IsGSTApplicable == "0")
                                       { %>
                                    <th class="GridViewHeaderStyle" style="width: 75px">Other Chrages</th>
                                     <% } %>
                                    <th class="GridViewHeaderStyle" style="width: 75px">Net Amt.</th>
                                    <th class="GridViewHeaderStyle" style="width: 70px">Exp Date</th>
                                    <th class="GridViewHeaderStyle" style="width: 25px">Free</th>
                                    <th class="GridViewHeaderStyle" style="width: 25px">Other Batch</th>
                                    <th class="GridViewHeaderStyle" style="width: 25px">Add</th>
                                    <th class="GridViewHeaderStyle" style="width: 25px">Update Master</th>
                                    <th class="GridViewHeaderStyle" style="width: 25px"></th>
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
                                <%if (Resources.Resource.IsGSTApplicable == "0")
                                  { %>
                                <input type="text" id="txtBillDiscPer" autocomplete="off" onkeyup="_onGRNAmountChange(this)" onblur="onTotalDiscountPercentChange(this)" discountontotal="0" maxlength="10" onlynumber="7" decimalplace="4" max-value="100" />
                                <%}
                                  else
                                  { %>
                                <input type="text" id="txtBillDiscPer" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" onblur="$UpdateFinalDiscount(function(){});" onkeyup="$ValidateTotalDiscount(function(){});" discountontotal="0" maxlength="10" onlynumber="7" decimalplace="4" max-value="100" />
                                <%} %>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bill Disc Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%if (Resources.Resource.IsGSTApplicable == "0")
                                  { %>
                                <input type="text" id="txtBillDiscAmt" autocomplete="off" onkeyup="_onGRNAmountChange(this)" onblur="onTotalDiscountAmountChange(this);" maxlength="10" onlynumber="10" decimalplace="4" max-value="1000000" />
                                <%}
                                  else
                                  { %>
                                <input type="text" id="txtBillDiscAmt" autocomplete="off" onblur="$UpdateFinalDiscount(function(){});" onkeypress="return checkForSecondDecimal(this,event);" onkeyup="$ValidateTotalDiscount(function(){});" maxlength="10" />
                                <%} %>
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

                            <%if (Resources.Resource.IsGSTApplicable == "0")
                              { %>
                                <div class="col-md-3">
                                    <label class="pull-left">VAT Amt</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" id="txtVATAmount" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                                </div>
                            <%}
                              else
                              { %>
                                      
                            <div class="col-md-3">
                                <label class="pull-left">CGST & SGST Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                               <%-- <input type="text" id="txtVATAmount" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" style="display:none;" />--%>
                                <input type="text" id="txtTotalCGST" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <div class="col-md-1">&</div>
                            <div class="col-md-2">
                                <input type="text" id="txtTotalSGST" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>

                            <%} %>
                            <div class="col-md-3">
                                <label class="pull-left">Freight Charges</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtFreight" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" onblur="GetValue()" value="0.00"/>
                            </div>

                        </div>
                        <div class="row">
                            <%if (Resources.Resource.IsGSTApplicable == "1")
                              { %>
                            <div class="col-md-3">
                                <label class="pull-left">IGST Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtTotalIGST" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">UTGST Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtTotalUTGST" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                            <%} %>

                            <div class="col-md-3">
                                <label class="pull-left">Total Discount Amt.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtTotalDiscount" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>

                            

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Narration</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine"
                                    CssClass="requiredField" AccessKey="N" ClientIDMode="Static"> </asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Currency</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <select id="ddlCurrency" onchange="getCurrencyFactor($(this).find('option:selected').val(),function(){});"> 
                                 </select>
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="txtCurrencyFactor" style="padding-left: 3px; color: blue" onlynumber="12" decimalplace="4" max-value="1000" class="patientInfo" title="Enter Currency Concersion Factor here"  />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">GRN Amt</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtInvoiceAmount" autocomplete="off" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">

                <div class="row">
                    <div class="col-md-8">
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: aqua" class="circle"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Free Items</b>
                    </div>
                    <div class="col-md-8 textCenter">
                        <input type="button" id="btnSaveGRN" value="Save" class="save" onclick="$SaveGRN(this, function () { });" />
                        <input type="button" id="btnCancelGRN" value="Cancel" class="save" onclick="$clear();" />
                        <label class="hidden" id="lblPurchaseOrderNumber"></label>
                    </div>
                    <div class="col-md-8"></div>

                </div>
            </div>
        </asp:Panel>

        <div id="divUpdateItemMaster" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 400px; height: 333px">
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
                                    <input type="text" id="txtUpdateCGSTPer" disabled="disabled" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    SGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateSGSTPer"  disabled="disabled" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    UTGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateUTGSTPer"  disabled="disabled" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    IGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateIGSTPer"  disabled="disabled" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
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

        <div id="divUpdatemasterVAT" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 350px; height: 315px">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" data-dismiss="divUpdatemasterVAT">&times;</button>
                    <h4 class="modal-title">Update Item master :
                        <label id="Label1" class="ItDoseLblError"></label>
                    </h4>
                    <span id="Span1" style="display: none;"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="chkUpdateCFVAT" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    Con. Fac. :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="TextConversionfactorVAT" onkeypress="return checkForSecondDecimal(this,event);" maxlength="5" />
                                </div>
                            </div>
                           <%-- <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="Checkbox2" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    HSN Code :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="Text2" maxlength="20" />
                                </div>
                            </div>--%>
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="chkUpdateVAT" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    VAT(%) :
                                </div>
                                <div class="col-md-14">
                                    <%--<asp:DropDownList ID="DropDownList1" runat="server" ClientIDMode="Static" onchange="$changeUpdateGSTType()"></asp:DropDownList>--%>
                                    <input type="text" id="txtUpdateVATPercent" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    VAT AMT :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="txtUpdateVATAmt" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>
                            <%--<div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    SGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="Text4" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>--%>
                            <%--<div class="row">
                                <div class="col-md-2">
                                </div>
                                <div class="col-md-8">
                                    IGST(%) :
                                </div>
                                <div class="col-md-14">
                                    <input type="text" id="Text5" onkeypress="return checkForSecondDecimal(this,event);" maxlength="10" />
                                </div>
                            </div>--%>
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="Checkbox4" checked="checked" />
                                </div>
                                <div class="col-md-8">
                                    IsExpirable :
                                </div>
                                <div class="col-md-14">
                                    <input type="checkbox" id="Checkbox5" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="text-align: center;">
                    <input type="button" value="OK" style="margin-top: 7px; width: 100px;" onclick="$BindUpdatesVAT()" />
                </div>
            </div>
        </div>
    </div>

    </div>

    <script type="text/javascript">

        //*****Global Variables*******
        var centerWiseMarkUp = [];
        var taxCalculationOn = [];
        //var getGst = [];

        var gstPercentage = [];
        //****************************


        $(document).ready(function () {
            $('#ddlVendor').chosen();
            getGSTPercentage();
            onInit(function () {
                getCurrencyDetails(function (SelectedCountryID) {
                    getCurrencyFactor(SelectedCountryID, function () { });

                    var editLedgerTransactionNo = '<%=Util.GetString(Request.QueryString["ledgerTransactionNo"])  %>';

                    if (!String.isNullOrEmpty(editLedgerTransactionNo))
                        onGRNEdit(editLedgerTransactionNo);

                });
                ShowRequiredField(function () { });
            });
        });


        var getGSTPercentage = function () {
            serverCall('../Store/Services/CommonService.asmx/GetTaxGroups', {}, function (response) {
                var responseData = JSON.parse(response);
                gstPercentage = responseData; //assign to global variables
            });
        }

        var onVendorChange = function (el) {



        }




        var ShowPurchaseOrder = function () {
            if ($('input[type=radio][name$=rbtIsConsignment]:checked').val() == "0")
                $("#btnShowPO").show();
            else
                $("#btnShowPO").hide();
        }

        var getCurrencyDetails = function (callback) {
            var ddlCurrency = $('#ddlCurrency');
            serverCall('../Common/CommonService.asmx/LoadCurrencyDetail', {}, function (response) {
                var responseData = JSON.parse(response);
                $(ddlCurrency).bindDropDown({
                    data: responseData.currancyDetails,
                    valueField: 'CountryID',
                    textField: 'Currency',
                    selectedValue: responseData.baseCountryID
                });
                callback(ddlCurrency.val());
            });
        }

        var getCurrencyFactor = function (CountryID, callback) {
            serverCall('DirectGRN.aspx/getCurrencyFactor', { CountryID: CountryID }, function (response) {
                var responseData = JSON.parse(response);
                $('#txtCurrencyFactor').val(responseData.Selling_Specific);
                callback(true);
            });
        }

        var getPurchaseMarkUpPercent = function (callback) {
            serverCall('../Store/Services/CommonService.asmx/GetPurchaseMarkUpPercent', {}, function (response) {
                var responseData = JSON.parse(response);
                centerWiseMarkUp = responseData; //assign to global variables
                callback(centerWiseMarkUp);
            });
        };

        var getTaxCalOn = function (callback) {
            serverCall('../Store/Services/CommonService.asmx/GetTaxCalOn', {}, function (response) {
                taxCalculationOn = JSON.parse(response); //assign to global variables
                callback(taxCalculationOn);
            })
        }


        var bindItems = function (data, callback) {
            serverCall('Services/WebService.asmx/GetItemList', data, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                        return {
                            label: item.ItemName,
                            val: item.ItemID,
                            ItemID: item.ItemID,
                            IsExpirable: item.IsExpirable,
                            minorUnit: item.minorUnit,
                            ConversionFactor: item.ConversionFactor,
                            majorUnit: item.majorUnit,
                            HSNCode: item.HSNCode,
                            SubCategoryID: item.SubCategoryID,
                            VatType: item.VatType,
                            DefaultSaleVatPercentage: item.DefaultSaleVatPercentage
                        }
                    }
                    else {
                        return {
                            label: item.ItemName,
                            val: item.ItemID,
                            ItemID: item.ItemID,
                            IsExpirable: item.IsExpirable,
                            minorUnit: item.minorUnit,
                            ConversionFactor: item.ConversionFactor,
                            majorUnit: item.majorUnit,
                            HSNCode: item.HSNCode,
                            SubCategoryID: item.SubCategoryID,
                            GSTType: item.GSTType,//VatType
                            DefaultSaleVatPercentage: item.TotalGSTPer,// item.DefaultSaleVatPercentage,
                            IGSTPercent: item.IGSTPercent,
                            CGSTPercent: item.CGSTPercent,
                            SGSTPercent: item.SGSTPercent,
                            GSTTypeNew: item.GSTTypeNew,
                            TotalGSTPer: item.TotalGSTPer
                        }
                    }
                });
                callback(responseData);
            });
        }


            var onInit = function (callback) {
                getPurchaseMarkUpPercent(function () {
                    getTaxCalOn(function () {
                        var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
                        addNewItemRow(0, storeLedgerNo, function (row) {
                            bindAutoComplete(row, function () { });
                            bindTaxCalculationOn(row, function () { });
                            $bindGSTTypee(row, function () { });//
                        });
                        callback(true);
                    });
                });
            }


            var bindAutoComplete = function (selectedRow, callback) {
                selectedRow.find('#txtItemName_').autocomplete({
                    source: processSearch,
                    select: function (e, i) {
                        var selectedRow = $(e.target).closest('tr');
                        var selectedItemDetails = $.extend({}, i);
                        validateControls(function () {
                            GetLastGRN(i.item.ItemID);
                            bindSelectedItemDetails(selectedRow, selectedItemDetails, function () { });
                        }, selectedRow);
                    },
                    close: function (e) { },
                    minLength: 2
                });
            }


            function GetLastGRN(Itemid) {
                $.ajax({
                    url: "Services/WebService.asmx/GetLastTenGrnList",
                    data: JSON.stringify({ ItemID: Itemid }),
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var Data = $.parseJSON(mydata.d);

                        if (Data != null) {
                            $('#tb_GRNList tbody').empty();
                            $('#tb_GRNList tbody').append('<tr><td class="GridViewHeaderStyle" style="width:30px;">Sr. No.</td><td class="GridViewHeaderStyle" style="width:200px;">GRN No.</td><td class="GridViewHeaderStyle" style="width:250px;">Item Name</td><td class="GridViewHeaderStyle" style="width:110spx;">Date</td><td class="GridViewHeaderStyle" style="width:90px; ">Rate</td><td class="GridViewHeaderStyle" style="width:250px;">Vendor Name</td><td class="GridViewHeaderStyle" style="width:80px;">MRP</td><td class="GridViewHeaderStyle" style="width:40px;">Disc%</td><td class="GridViewHeaderStyle" style="width:80px;">DiscAmt</td></tr>');
                            var sr = 1;
                            for (var i = 0; i < Data.length; i++) {
                                $('#tb_GRNList tbody').append('<tr><td>' + sr + '</td><td>' + Data[i].LedgerTransactionNo + '</td><td>' + Data[i].ItemName + '</td><td>' + Data[i].GRNDate + '</td><td style="text-align:center;">' + Data[i].Rate + '</td><td>' + Data[i].VendorName + '</td><td style="text-align:center;">' + Data[i].Mrp + '</td><td style="text-align:center;">' + Data[i].DiscPer + '</td><td style="text-align:center;">' + Data[i].DiscAmt + '</td></tr>');
                                sr++;
                            }
                            $('#divGRNList').showModel();
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        var err = eval("(" + XMLHttpRequest.responseText + ")");
                        alert(err.Message)
                    },
                });
            }

            var bindTaxCalculationOn = function (selectedRow, callback) {
                selectedRow.find('#ddlTaxCalOn_').bindDropDown({ data: taxCalculationOn });
            }

            $bindGSTTypeeForSamebatch = function (el, rowtocopy, ddl, callback) {
                var selectedRow = $(el).closest('tr');
                selectedRow.find('[id^=ddlGSTType_]').empty();
                // $('#ddlGSTType_' + id).empty();
                //serverCall('Services/WebService.asmx/bindGSTType', callback, function (response) {
                //    var Data = $.parseJSON(response);
                //    for (var i = 0; i < Data.length; i++) {
                //        //$('#ddlGSTType_' + id).append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                //        selectedRow.find('[id^=ddlGSTType_]').append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                //    }
                //    var ddlselect = rowtocopy.find('select');
                //    for (var j = 0; j < ddlselect.length; j++) {
                //        if (j == 1) {
                //            selectedRow.find('#' + ddlselect[j].id).val(ddl);
                //        }
                //    }
                //    callback(true);
                //});



                selectedRow.find('[id^=ddlGSTType_]').bindDropDown({ data: gstPercentage, valueField: 'id', textField: 'TaxGroupLabel', isSearchable: false });
                var ddlselect = rowtocopy.find('select');
                for (var j = 0; j < ddlselect.length; j++) {
                    if (j == 1) {
                        selectedRow.find('#' + ddlselect[j].id).val(ddl);
                    }
                }
                callback(true);
            }

            $bindGSTTypee = function (el, callback) {
                var selectedRow = $(el).closest('tr');
                selectedRow.find('[id^=ddlGSTType_]').empty();
                // $('#ddlGSTType_' + id).empty();
                //serverCall('Services/WebService.asmx/bindGSTType', callback, function (response) {
                //    var Data = $.parseJSON(response);
                //    for (var i = 0; i < Data.length; i++) {
                //        //$('#ddlGSTType_' + id).append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                //        selectedRow.find('[id^=ddlGSTType_]').append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                //    }
                //    callback(true);
                //});


                selectedRow.find('[id^=ddlGSTType_]').bindDropDown({ data: gstPercentage, valueField: 'id', textField: 'TaxGroupLabel', isSearchable: false });
                callback(true);
            }


            var processSearch = function (request, response) {
                var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
                var IsConsignment = $('input[type=radio][name$=rbtIsConsignment]:checked').val();
                bindItems({ itemName: request.term, storeLedgerNo: storeLedgerNo, isConsignment: IsConsignment }, function (responseItems) {
                    response(responseItems)
                });
            }




            var onAddNewRow = function (el) {
                var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
                addNewItemRow(0, storeLedgerNo, function (row) {
                    bindAutoComplete(row, function () { });
                    bindTaxCalculationOn(row, function () { });
                    $bindGSTTypee(row, function () { });
                    $changeTaxType(row, function () { });
                });
            }


            var onAddFreeItem = function (el, rowid) {
                var selectedItemID = $(el).closest('tr').find('[id^=spnItemId_]').text();
                var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());

                if (selectedItemID != "") {
                    var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
                    addNewItemRow(1, storeLedgerNo, function (selectedRow) {

                        if (!String.isNullOrEmpty(selectedPurchaseOrder))
                            selectedRow.find('#btnAdd_').addClass('hidden');


                        var rowToCopy = $(el).closest('tr');
                        var textFieldToCopy = rowToCopy.find('input[type=text]');

                        if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                            for (var i = 0; i < textFieldToCopy.length; i++) {
                                selectedRow.find('#' + textFieldToCopy[i].id).val(textFieldToCopy[i].value);
                            }
                        }
                        else if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                            ddl = $(el).closest('tr').find('[id^=ddlGSTType_]').val();
                            $bindGSTTypeeForSamebatch(selectedRow, rowToCopy, ddl, function () { });//
                            var newrowid = $("#tb_ItemsList tbody tr").length;
                            for (var i = 0; i < textFieldToCopy.length; i++) {
                                if (textFieldToCopy[i].id == "txtIGST_" + rowid) {
                                    //if (textFieldToCopy[i].value == 0) {
                                    //    $("#txtIGST_" + newrowid).attr("disabled", true);
                                    //}
                                    $("#txtIGST_" + newrowid).val(textFieldToCopy[i].value);
                                }
                                if (textFieldToCopy[i].id == "txtSGST_" + rowid) {
                                    //if (textFieldToCopy[i].value == 0) {
                                    //    $("#txtSGST_" + newrowid).attr("disabled", true);
                                    //}
                                    $("#txtSGST_" + newrowid).val(textFieldToCopy[i].value);
                                }
                                if (textFieldToCopy[i].id == "txtCGST_" + rowid) {
                                    //if (textFieldToCopy[i].value == 0) {
                                    //    $("#txtCGST_" + newrowid).attr("disabled", true);
                                    //}
                                    $("#txtCGST_" + newrowid).val(textFieldToCopy[i].value);
                                }
                                selectedRow.find('#' + textFieldToCopy[i].id).val(textFieldToCopy[i].value);

                            }
                        }

                        selectedRow.find('[id^=txtSpclDiscPer_]').attr("disabled", true);

                        var labeltoCopy = rowToCopy.find('span');
                        if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                            for (var i = 0; i < labeltoCopy.length; i++) {
                                selectedRow.find('#' + labeltoCopy[i].id).text(labeltoCopy[i].innerText);
                            }
                        }
                        else if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                            //spnPurchaseSalesUnit_
                            for (var i = 0; i < labeltoCopy.length; i++) {
                                if (labeltoCopy[i].id != "spnNetAmount_") {
                                    selectedRow.find('#' + labeltoCopy[i].id).text(labeltoCopy[i].innerText);
                                }
                                if (labeltoCopy[i].id == "spnCGSTAmt_") {
                                    selectedRow.find('#' + labeltoCopy[i].id).text(0);
                                }
                                if (labeltoCopy[i].id == "spnSGSTAmt_") {
                                    selectedRow.find('#' + labeltoCopy[i].id).text(0);
                                }
                                if (labeltoCopy[i].id == "spnIGSTAmt_") {
                                    selectedRow.find('#' + labeltoCopy[i].id).text(0);
                                }
                                if (labeltoCopy[i].id == "spnUTGSTAmt_") {
                                    selectedRow.find('#' + labeltoCopy[i].id).text(0);
                                }
                                if (labeltoCopy[i].id == "spnGrossAmt_") {
                                    selectedRow.find('#' + labeltoCopy[i].id).text(0);
                                }
                                //if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4) {
                                //    selectedRow.find('#' + labeltoCopy[i].id).text(labeltoCopy[i].innerText);
                                //}
                            }
                        }
                        selectedRow.find('.tdData').text(rowToCopy.find('.tdData').text());
                        selectedRow.find('.tdTaxDetails').text(rowToCopy.find('.tdTaxDetails').text());
                        setIsFreeDefaultValue(selectedRow, function () { });
                        bindAutoComplete(selectedRow, function () { });
                        bindTaxCalculationOn(selectedRow, function () { });
                        calculateGRNSummary(function () { });
                    });
                }
                else {
                    modelAlert('Please Select a Valid Item', function () {
                        $(el).closest('tr').find('[id^=txtItemName_]').focus();
                    });
                }
            }



            var onAddSameBatchItem = function (el, rowid) {
                var ddl = ""; var newrowid = "";
                var selectedItemID = $(el).closest('tr').find('[id^=spnItemId_]').text();
                var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());


                if (selectedItemID != "") {

                    var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
                    addNewItemRow(0, storeLedgerNo, function (selectedRow) {


                        if (!String.isNullOrEmpty(selectedPurchaseOrder))
                            selectedRow.find('#btnAdd_').addClass('hidden');

                        var rowToCopy = $(el).closest('tr');

                        var textFieldToCopy = rowToCopy.find('input[type=text]');

                        var labeltoCopy = rowToCopy.find('span');
                        var isfree = 0;
                        if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                        for (var i = 0; i < labeltoCopy.length; i++) {
                            if (labeltoCopy[i].id == "spnIsFree_") {
                                isfree = labeltoCopy[i].innerText;
                            }
                        }

                        // if (isfree == 0) {
                        ddl = $(el).closest('tr').find('[id^=ddlGSTType_]').val();
                        $bindGSTTypeeForSamebatch(selectedRow, rowToCopy, ddl, function () { });//
                        //newrowid = rowid;

                        //newrowid++;
                        newrowid = $("#tb_ItemsList tbody tr").length;
                        for (var i = 0; i < textFieldToCopy.length; i++) {
                            if (textFieldToCopy[i].id == "txtIGST_" + rowid) {
                                //if (textFieldToCopy[i].value == 0) {
                                //    $("#txtIGST_" + newrowid).attr("disabled", true);
                                //}
                                $("#txtIGST_" + newrowid).val(textFieldToCopy[i].value);
                            }
                            if (textFieldToCopy[i].id == "txtSGST_" + rowid) {
                                //if (textFieldToCopy[i].value == 0) {
                                //    $("#txtSGST_" + newrowid).attr("disabled", true);
                                //}
                                $("#txtSGST_" + newrowid).val(textFieldToCopy[i].value);
                            }
                            if (textFieldToCopy[i].id == "txtCGST_" + rowid) {
                                //if (textFieldToCopy[i].value == 0) {
                                //    $("#txtCGST_" + newrowid).attr("disabled", true);
                                //}
                                $("#txtCGST_" + newrowid).val(textFieldToCopy[i].value);
                            }
                        }

                        //}
                    }

                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                        for (var i = 0; i < textFieldToCopy.length; i++) {//
                            if (textFieldToCopy[i].id != "txtBatchNo_") {
                                selectedRow.find('#' + textFieldToCopy[i].id).val(textFieldToCopy[i].value);
                            }
                            if (textFieldToCopy[i].id == "txtNetAmount_") {
                                selectedRow.find('#' + textFieldToCopy[i].id).val(0);
                            }
                            if (textFieldToCopy[i].id == "txtQty_") {
                                selectedRow.find('#' + textFieldToCopy[i].id).val(0);
                            }
                        }
                    }
                    else {
                        for (var i = 0; i < textFieldToCopy.length; i++) {
                            selectedRow.find('#' + textFieldToCopy[i].id).val(textFieldToCopy[i].value);
                        }
                    }

                    //var labeltoCopy = rowToCopy.find('span');

                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                        for (var i = 0; i < labeltoCopy.length; i++) {
                            if (labeltoCopy[i].id != "spnNetAmount_") {
                                if (labeltoCopy[i].id == "spnIsFree_") {
                                    if (isfree == 1) {
                                        selectedRow.find('#' + labeltoCopy[i].id).text(1);

                                        selectedRow.find('[id^=txtDiscAmt_]').attr("disabled", true);
                                        selectedRow.find('[id^=txtDiscPer_]').attr("disabled", true);
                                        selectedRow.find('[id^=txtSpclDiscPer_]').attr("disabled", true);
                                    }
                                    else {
                                        selectedRow.find('#' + labeltoCopy[i].id).text(labeltoCopy[i].innerText);

                                        selectedRow.find('[id^=txtDiscAmt_]').attr("disabled", false);
                                        selectedRow.find('[id^=txtDiscPer_]').attr("disabled", false);
                                        selectedRow.find('[id^=txtSpclDiscPer_]').attr("disabled", false);
                                    }
                                }
                                else {
                                    selectedRow.find('#' + labeltoCopy[i].id).text(labeltoCopy[i].innerText);
                                }
                            }
                        }
                    }
                    else {
                        for (var i = 0; i < labeltoCopy.length; i++) {
                            selectedRow.find('#' + labeltoCopy[i].id).text(labeltoCopy[i].innerText);
                        }
                    }
                    selectedRow.find('.tdData').text(rowToCopy.find('.tdData').text());
                    selectedRow.find('.tdTaxDetails').text(rowToCopy.find('.tdTaxDetails').text());
                    selectedRow.find('[id^=txtItemName_]').attr('disabled', true);
                    selectedRow.find('[id^=spnFreeAgainstItemID_]').val('');

                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                        selectedRow.find('[id^=spnIsFree_]').text(0);
                    }
                    selectedRow.find('[id=txtExp_]').addClass(rowToCopy.find('[id=txtExp_]').attr('class'));

                    selectedRow.find('[id=txtQty_]').attr('title', rowToCopy.find('[id=txtQty_]').attr('title'));
                    selectedRow.find('[id=txtRate_]').attr('title', rowToCopy.find('[id=txtRate_]').attr('title'));

                    bindAutoComplete(selectedRow, function () { });
                    bindTaxCalculationOn(selectedRow, function () { });
                    calculateGRNSummary(function () { });

                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                        // $UpdateAmounts(function () { });
                    }
                });
            }
            else {
                modelAlert('Please Select a Valid Item', function () {
                    $(el).closest('tr').find('[id^=txtItemName_]').focus();
                });
            }
        }

        var setIsFreeDefaultValue = function (selectedRow, callback) {
            selectedRow.find('[id^=spnIsFree_]').text(1);
            selectedRow.find('[id^=txtVATAmount_]').val(0);
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                selectedRow.find('[id^=txtMrp_]').val(0);
            }
            selectedRow.find('[id^=txtQty_]').val(0);
            selectedRow.find('[id^=txtOtherCharges_]').val(0);
            selectedRow.find('[id^=txtNetAmount_]').val(0);
            selectedRow.find('[id^=spnOtherCharges_]').text(0);
            selectedRow.find('[id^=spnNetAmount_]').text(0);
            selectedRow.find('[id^=txtDiscPer_]').val(0).attr('disabled', true);
            selectedRow.find('[id^=txtDiscAmt_]').val(0).attr('disabled', true);
            selectedRow.find('[id^=txtOtherCharges_]').val(0);
            selectedRow.find('[id^=spnFreeAgainstItemID_]').val(selectedRow.find('[id^=spnItemId_]').text());
            selectedRow.addClass('freeItemRow');
            callback();
        }





        var removeRow = function (el, callback) {
            var selectedElem = $(el);
            var selectedRow = $(el).closest('tr');
            var ledgerTnxNo = Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').attr('ledgerTnxNo'));
            var stockNo = Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').attr('stockNo'));

            if (ledgerTnxNo > 0) {

                modelConfirmation('Confirmation', 'Are you sure want to delete this item', 'Yes', 'Close', function (status) {
                    if (status) {
                        serverCall('DirectGRN.aspx/RemoveGRNItem', { ledgerTnxNo: ledgerTnxNo, stockNo: stockNo }, function (response) {

                            var responseData = JSON.parse(response);
                            if (responseData.status)
                                removeGRNItemRow(selectedElem);
                            else
                                modelAlert(responseData.message);

                        });
                    }
                });
            }
            else {
                var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());
                if (!String.isNullOrEmpty(selectedPurchaseOrder)) {
                    var purchaseOrderItems = $(selectedRow).closest('tbody').find('tr');
                    if (purchaseOrderItems.length == 1)
                        modelAlert('PO GRN have Atleast One Item.', function () { });
                    else
                        removeGRNItemRow(selectedElem);
                }
                else
                    removeGRNItemRow(selectedElem);
            }

        }



        var removeGRNItemRow = function (el) {
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
                var totalRows = $(el).closest('table tbody');
                $(el).closest('tr').remove();
                totalRows.find('tr:last').find('#btnAdd_,#btnAddFree_,#btnAddSameBatch_').removeClass('hidden');

                var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());

                if (!String.isNullOrEmpty(selectedPurchaseOrder))
                    totalRows.find('tr:last').find('#btnAdd_').addClass('hidden');

                if (totalRows.find('tr').length == 0) {
                    onAddNewRow();
                }

                calculateGRNSummary(function () { });
            }
            else {
                var totalRows = $(el).closest('table tbody');
                $(el).closest('tr').remove();
                totalRows.find('tr:last').find('#btnAdd_,#btnAddFree_,#btnAddSameBatch_').removeClass('hidden');

                var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());

                if (!String.isNullOrEmpty(selectedPurchaseOrder))
                    totalRows.find('tr:last').find('#btnAdd_').addClass('hidden');

                if (totalRows.find('tr').length == 0) {
                    onAddNewRow();
                }

                $('#txtTotalUTGST').val("0.0000");
                $('#txtTotalSGST').val("0.0000");
                $UpdateAmounts(function () { });
            }
        }


        $changeTaxType = function (el, callback) {//
            var selectedRow = $(el).closest('tr');
            // if (selectedRow.find('[id^=ddlGSTType_]').val() == "T4") {
            //selectedRow.find('[id^=txtIGST_]').attr('disabled', false);
            //selectedRow.find('[id^=txtCGST_]').attr('disabled', true);
            //selectedRow.find('[id^=txtSGST_]').attr('disabled', true);
            // }
            //  else {
            //selectedRow.find('[id^=txtIGST_]').attr('disabled', true);
            //selectedRow.find('[id^=txtCGST_]').attr('disabled', false);
            //selectedRow.find('[id^=txtSGST_]').attr('disabled', false);
            // }

            //dev
            var ID = selectedRow.find('[id^=ddlGSTType_]').val();
            var filterGST = gstPercentage.filter(function (i) { return i.id == ID });


            selectedRow.find('[id^=txtIGST_]').val('0.0');
            selectedRow.find('[id^=txtCGST_]').val('0.0');
            selectedRow.find('[id^=txtSGST_]').val('0.0');

            if (filterGST[0].TaxGroup.toUpperCase() == 'IGST') {
                selectedRow.find('[id^=txtIGST_]').val(filterGST[0].IGSTPer);

            } else if (filterGST[0].TaxGroup.toUpperCase() == 'CGST&SGST') {
                selectedRow.find('[id^=txtCGST_]').val(filterGST[0].CGSTPer);
                selectedRow.find('[id^=txtSGST_]').val(filterGST[0].SGSTPer);
            }
            else {
                selectedRow.find('[id^=txtCGST_]').val(filterGST[0].CGSTPer);
                selectedRow.find('[id^=txtSGST_]').val(filterGST[0].UTGSTPer);
            }

            callback(true);
        }
        $getTaxCalculations = function (el, callback) {//
            var selectedRow = $(el).closest('tr');//
            $DiscPer = 0; $DiscAmt = 0; $Rate = 0; $MRP = 0; $QTY = 0; $Deal1 = 0; $Deal2 = 0; $spclDiscPer = 0; $spclDiscAmt = 0;
            $CGSTPer = 0; $SGSTPer = 0; $IGSTPer = 0; $BillDiscPer = 0; $BillDiscAmt = 0; $BillGrossAmt = 0;

            $Type = "RateAD";    //$('#ddlTaxCalOn_' + id).val();
            if (selectedRow.find('[id^=txtDiscPer_]').val() != "")
                $DiscPer = parseFloat(selectedRow.find('[id^=txtDiscPer_]').val());
            if (selectedRow.find('[id^=txtDiscAmt_]').val() != "" && selectedRow.find('[id^=spnIsFree_]').text() == "0")
                $DiscAmt = parseFloat(selectedRow.find('[id^=txtDiscAmt_]').val());
            if (selectedRow.find('[id^=txtRate_]').val() != "" && selectedRow.find('[id^=spnIsFree_]').text() == "0")
                $Rate = parseFloat(selectedRow.find('[id^=txtRate_]').val());
            if (selectedRow.find('[id^=txtMrp_]').val() != "")
                $MRP = parseFloat(selectedRow.find('[id^=txtMrp_]').val());
            if (selectedRow.find('[id^=txtQty_]').val() != "")
                $QTY = parseFloat(selectedRow.find('[id^=txtQty_]').val());
            if (selectedRow.find('[id^=txtDeal1_]').val() != "")
                $Deal1 = parseFloat(selectedRow.find('[id^=txtDeal1_]').val());
            if (selectedRow.find('[id^=txtDeal2_]').val() != "")
                $Deal2 = parseFloat(selectedRow.find('[id^=txtDeal2_]').val());
            if (selectedRow.find('[id^=txtSpclDiscPer_]').val() != "")
                $spclDiscPer = parseFloat(selectedRow.find('[id^=txtSpclDiscPer_]').val());
            if (selectedRow.find('[id^=txtSpclDiscPer_]').val() != "" && selectedRow.find('[id^=spnIsFree_]').text() == "0")
                $spclDiscAmt = parseFloat(selectedRow.find('[id^=txtSpclDiscPer_]').val());
            if (selectedRow.find('[id^=txtCGST_]').val() != "")
                $CGSTPer = parseFloat(selectedRow.find('[id^=txtCGST_]').val());
            if (selectedRow.find('[id^=txtSGST_]').val() != "")
                $SGSTPer = parseFloat(selectedRow.find('[id^=txtSGST_]').val());
            if (selectedRow.find('[id^=txtIGST_]').val() != "")
                $IGSTPer = parseFloat(selectedRow.find('[id^=txtIGST_]').val());
            if ($('#txtBillDiscPer').val() != "")
                $BillDiscPer = parseFloat($.trim($('#txtBillDiscPer').val()));
            if ($('#txtBillDiscAmt').val() != "")
                $BillDiscAmt = parseFloat($.trim($('#txtBillDiscAmt').val()));
            if ($('#txtBillGrossAmt').val() != "")
                $BillGrossAmt = parseFloat($.trim($('#txtBillGrossAmt').val()));

            serverCall('Services/WebService.asmx/TaxCalculation', { BillDiscPer: $BillDiscPer, BillDiscAmt: $BillDiscAmt, BillGrossAmt: $BillGrossAmt, DiscPer: $DiscPer, DiscAmt: $DiscAmt, Rate: $Rate, MRP: $MRP, QTY: $QTY, Deal1: 0, Deal2: 0, spclDiscPer: $spclDiscPer, spclDiscAmt: $spclDiscAmt, CGSTPer: $CGSTPer, SGSTPer: $SGSTPer, IGSTPer: $IGSTPer, Type: $Type }, function (response) {
                $Data = response;
                selectedRow.find('[id^=spnNetAmount_]').text($Data.split('#')[0]);
                selectedRow.find('[id^=spnIGSTAmt_]').text($Data.split('#')[8]);
                selectedRow.find('[id^=spnCGSTAmt_]').text($Data.split('#')[9]);

                var ID = selectedRow.find('[id^=ddlGSTType_]').val();
                var filterGST = gstPercentage.filter(function (i) { return i.id == ID });


                if (filterGST[0].TaxGroup.toUpperCase() == 'CGST&SGST') {
                    selectedRow.find('[id^=spnSGSTAmt_]').text($Data.split('#')[10]);
                    selectedRow.find('[id^=spnUTGSTAmt_]').text(0);
                }
                else if (filterGST[0].TaxGroup.toUpperCase() == 'CGST&UTGST') {
                    selectedRow.find('[id^=spnUTGSTAmt_]').text($Data.split('#')[10]);
                    selectedRow.find('[id^=spnSGSTAmt_]').text(0);
                }
                else {
                    selectedRow.find('[id^=spnUTGSTAmt_]').text(0);
                    selectedRow.find('[id^=spnSGSTAmt_]').text(0);
                }

                selectedRow.find('[id^=spnDiscPer_]').text($Data.split('#')[12]);
                selectedRow.find('[id^=spnDiscAmt_]').text($Data.split('#')[2]);
                selectedRow.find('[id^=txtDiscAmt_]').val($Data.split('#')[2]);//
                selectedRow.find('[id^=spnGrossAmt_]').text($Data.split('#')[3]);
                selectedRow.find('[id^=spnUnitPrice_]').text($Data.split('#')[4]);

                selectedRow.find('[id^=spnSpclDiscPer_]').text($Data.split('#')[13]);
                selectedRow.find('[id^=spnSpclDiscAmt_]').text($Data.split('#')[11]);

                $isOnSellingPrice = parseInt(selectedRow.find('[id^=spnIsOnSellingPrice]').text());//$.trim($('#spnIsOnSellingPrice' + id).text())
                $SellingMarginPer = parseFloat(selectedRow.find('[id^=spnIsOnSellingPrice]').text());//$.trim($('#spnIsOnSellingPrice' + id).text())
                if ($isOnSellingPrice == 1) {
                    $marginAmt = parseFloat((parseFloat($Data.split('#')[4]) * $SellingMarginPer) / 100);
                    $NetMRPAmt = Number(parseFloat($Data.split('#')[4]) + $marginAmt).toFixed(4);
                    // $('#txtMrp_' + id).val($NetMRPAmt);
                    selectedRow.find('[id^=txtMrp_]').val($NetMRPAmt);
                }


                $UpdateAmounts(function () { });
            });



            callback(true);
        }

        $UpdateAmounts = function (callback) {
            $NetAmt = 0; $RoundOff = 0; $CGSTAmt = 0; $SGSTAmt = 0; $IGSTAmt = 0; $TempAmt = 0;
            $DiscAmt = 0; $GrossAmt = 0; $SpclDiscAmt = 0; $UTGSTAmt = 0;
            //$('#tb_ItemsList tbody tr').each(function () {
            //    $rowid = $(this).closest('tr').attr('id').split('_')[1];
            //    if ($('#spnIsReturn_' + $rowid).text() == "1") {
            //        $NetAmt -= parseFloat($('#spnNetAmount_' + $rowid).text());
            //        $CGSTAmt -= parseFloat($('#spnCGSTAmt_' + $rowid).text());
            //        $SGSTAmt -= parseFloat($('#spnSGSTAmt_' + $rowid).text());
            //        $IGSTAmt -= parseFloat($('#spnIGSTAmt_' + $rowid).text());
            //        $GrossAmt -= parseFloat($('#spnGrossAmt_' + $rowid).text());
            //        $DiscAmt -= parseFloat($('#spnDiscAmt_' + $rowid).text());
            //    }
            //    else {

            //        $NetAmt += parseFloat($('#spnNetAmount_' + $rowid).text());
            //        $CGSTAmt += parseFloat($('#spnCGSTAmt_' + $rowid).text());
            //        $SGSTAmt += parseFloat($('#spnSGSTAmt_' + $rowid).text());
            //        $IGSTAmt += parseFloat($('#spnIGSTAmt_' + $rowid).text());
            //        $GrossAmt += parseFloat($('#spnGrossAmt_' + $rowid).text());
            //        $DiscAmt += parseFloat($('#spnDiscAmt_' + $rowid).text());
            //    }

            //});

            $('#tb_ItemsList tbody tr').each(function () {
                var selectedRow = $(this);
                if (selectedRow.find('[id^=spnIsReturn_]').text() == "1") {
                    $NetAmt -= parseFloat(selectedRow.find('[id^=spnNetAmount_]').text());
                    $CGSTAmt -= parseFloat(selectedRow.find('[id^=spnCGSTAmt_]').text());
                    $SGSTAmt -= parseFloat(selectedRow.find('[id^=spnSGSTAmt_]').text());
                    $UTGSTAmt -= parseFloat(selectedRow.find('[id^=spnUTGSTAmt_]').text());
                    $IGSTAmt -= parseFloat(selectedRow.find('[id^=spnIGSTAmt_]').text());
                    $GrossAmt -= parseFloat(selectedRow.find('[id^=spnGrossAmt_]').text());
                    $DiscAmt -= parseFloat(selectedRow.find('[id^=spnDiscAmt_]').text());
                    $SpclDiscAmt -= parseFloat(selectedRow.find('[id^=spnSpclDiscAmt_]').text());

                    var netamt = Number($(selectedRow).find('[id^=spnNetAmount_]').text())
                    selectedRow.find('[id^=txtNetAmount_]').val(Number(netamt).toFixed(4));
                }
                else {

                    $NetAmt += parseFloat(selectedRow.find('[id^=spnNetAmount_]').text());
                    $CGSTAmt += parseFloat(selectedRow.find('[id^=spnCGSTAmt_]').text());
                    $SGSTAmt += parseFloat(selectedRow.find('[id^=spnSGSTAmt_]').text());
                    $UTGSTAmt += parseFloat(selectedRow.find('[id^=spnUTGSTAmt_]').text());
                    $IGSTAmt += parseFloat(selectedRow.find('[id^=spnIGSTAmt_]').text());
                    $GrossAmt += parseFloat(selectedRow.find('[id^=spnGrossAmt_]').text());
                    $DiscAmt += parseFloat(selectedRow.find('[id^=spnDiscAmt_]').text());
                    $SpclDiscAmt += parseFloat(selectedRow.find('[id^=spnSpclDiscAmt_]').text());

                    var netamt = Number($(selectedRow).find('[id^=spnNetAmount_]').text());
                    selectedRow.find('[id^=txtNetAmount_]').val(Number(netamt).toFixed(4));
                }

            });
            $('#txtTotalIGST').val(Number($IGSTAmt).toFixed(4));
            $('#txtTotalCGST').val(Number($CGSTAmt).toFixed(4));
            //if (selectedRow.find('[id^=ddlGSTType_]').val() == "T7") {
            //    $("#txtTotalSGST").val(Number($SGSTAmt).toFixed(4));
            //    $('#txtTotalUTGST').val(Number($UTGSTAmt).toFixed(4));
            //}
            //else if (selectedRow.find('[id^=ddlGSTType_]').val() == "T6") {
            //    $('#txtTotalUTGST').val(Number($UTGSTAmt).toFixed(4))
            //    $('#txtTotalSGST').val(Number($SGSTAmt).toFixed(4));
            //}
            //else {
            //    $('#txtTotalUTGST').val(Number($UTGSTAmt).toFixed(4));
            //    $('#txtTotalSGST').val(Number($SGSTAmt).toFixed(4));
            //}

            $('#txtTotalSGST').val(0);
            $('#txtTotalUTGST').val(0);
            if ($UTGSTAmt > 0) {
                $('#txtTotalUTGST').val(Number($UTGSTAmt).toFixed(4));
            }
            if ($SGSTAmt > 0) {
                $('#txtTotalSGST').val(Number($SGSTAmt).toFixed(4));
            }

            $('#txtBillGrossAmt').val(Number($GrossAmt).toFixed(4));

            $TempAmt = Number($NetAmt).toFixed(0);
            $RoundOff = Number(parseFloat($TempAmt) - parseFloat($NetAmt)).toFixed(4);

            // var ledgertnxnumber = Number('<%=Util.GetString(Request.QueryString["ledgerTransactionNo"])  %>');

            $('#txtInvoiceAmount').val($TempAmt);

            $('#txtRoundOff').val($RoundOff);


            $('#txtTotalDiscount').val(Number($DiscAmt + $SpclDiscAmt).toFixed(4));
            callback(true);
        }

        function checkForSecondDecimal(sender, e) {//
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

        $ValidateMRP = function (el, callback) {//
            var selectedRow = $(el).closest('tr');
            $rate = 0; $MRP = 0;
            if (selectedRow.find('[id^=txtRate_]').val() != "")
                $rate = parseFloat(selectedRow.find('[id^=txtRate_]').val());
            if (selectedRow.find('[id^=txtMrp_]').val() != "")
                $MRP = parseFloat(selectedRow.find('[id^=txtMrp_]').val());
            if ($rate > $MRP) {
                alert('MRP cannot be less than Rate');
                $('#txtMrp_' + id).focus();
            }

            callback(true);
        }

        $ValidateTotalDiscount = function (callback) {
            if ($("#txtBillDiscPer").val() != "") {
                if ($("#txtBillDiscPer").val() > 100) {
                    alert('Discount Cannot be Greater than 100%');
                    return false;
                }
            }

            if ($("#txtBillDiscAmt").val() != "") {
                $DiscAmt = 0; $GRNAmt = 0;
                $DiscAmt = $("#txtBillDiscAmt").val();
                $GRNAmt = $("#txtInvoiceAmount").val();
                //$('#tb_ItemsList tbody tr').each(function () {
                //    //$rowid = $(this).closest('tr').attr('id').split('_')[1];
                //    var selectedRoww = $(this);
                //    if (selectedRoww.find('[id^=txtDiscPer_]').val() != "" || selectedRoww.find('[id^=txtDiscAmt_]').val() != "" || selectedRoww.find('[id^=txtSpclDiscPer_]').val() != "") {
                //        totaldiscAmt += selectedRoww.find('[id^=txtDiscAmt_]').val();
                //    }
                //});
                if ($DiscAmt > $GRNAmt) {
                    alert('Discount Cannot be Greater than GRN amount');
                    return false;
                }
            }
            callback(true);
        }

        $ValidateDiscount = function (el, callback) {
            var selectedRow = $(el).closest('tr');
            $('#txtBillDiscAmt,#txtBillDiscPer').removeAttr('disabled');
            $('#txtBillDiscAmt').show();
            $('#txtTotalItemWiseDisc').hide();
            $('#tb_ItemsList tbody tr').each(function () {
                //$rowid = $(this).closest('tr').attr('id').split('_')[1];
                var selectedRoww = $(this);
                if (selectedRoww.find('[id^=txtDiscPer_]').val() != "" || selectedRoww.find('[id^=txtDiscAmt_]').val() != "" || selectedRoww.find('[id^=txtSpclDiscPer_]').val() != "" || selectedRoww.find('[id^=txtSpclDiscAmt_]').val() != "") {
                    $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
                    $('#txtBillDiscAmt').hide();
                    $('#txtTotalItemWiseDisc').show();

                }
            });
            $DiscPer = 0; $DiscAmt = 0; $Rate = 0; $QTY = 0; $spclDiscPer = 0; $spclDiscAmt = 0;
            $BillDiscPer = 0; $BillDiscAmt = 0; $BillGrossAmt = 0;
            if (selectedRow.find('[id^=txtDiscPer_]').val() != "")
                $DiscPer = parseFloat(selectedRow.find('[id^=txtDiscPer_]').val());
            if (selectedRow.find('[id^=txtDiscAmt_]').val() != "")
                $DiscAmt = parseFloat(selectedRow.find('[id^=txtDiscAmt_]').val());
            if (selectedRow.find('[id^=txtRate_]').val() != "")
                $Rate = parseFloat(selectedRow.find('[id^=txtRate_]').val());
            if (selectedRow.find('[id^=txtQty_]').val() != "")
                $QTY = parseFloat(selectedRow.find('[id^=txtQty_]').val());
            if (selectedRow.find('[id^=txtSpclDiscPer_]').val() != "")
                $spclDiscPer = parseFloat(selectedRow.find('[id^=txtSpclDiscPer_]').val());
            if (selectedRow.find('[id^=txtSpclDiscAmt_]').val() != "")
                $spclDiscAmt = parseFloat(selectedRow.find('[id^=txtSpclDiscAmt_]').val());
            if ($('#txtBillDiscPer').val() != "")
                $BillDiscPer = parseFloat($.trim($('#txtBillDiscPer').val()));
            if ($('#txtBillDiscAmt').val() != "")
                $BillDiscAmt = parseFloat($.trim($('#txtBillDiscAmt').val()));
            if ($('#txtBillGrossAmt').val() != "")
                $BillGrossAmt = parseFloat($.trim($('#txtBillGrossAmt').val()));

            //if ($DiscPer != 0) {
            //    selectedRow.find('[id^=txtDiscAmt_]').val('');
            //    $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
            //    $('#txtBillDiscAmt').hide();
            //    $('#txtTotalDiscount').show();
            //}
            //if ($DiscAmt != 0) {
            //    selectedRow.find('[id^=txtDiscPer_]').val('');
            //    $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
            //    $('#txtBillDiscAmt').hide();
            //    $('#txtTotalDiscount').show();
            //}
            if ($DiscPer > 100) {
                alert('Discount Cannot be Greater than 100%');
                //   $('#txtDiscPer_' + id).val('');
                selectedRow.find('[id^=txtDiscPer_]').val('');
                return false;
            }
            if (($Rate * $QTY) < $DiscAmt) {
                alert('Discount Amount cannot be Greater than Gross Amount');
                //$('#txtDiscAmt_' + id).val('');
                selectedRow.find('[id^=txtDiscAmt_]').val('');
            }
            if ($spclDiscPer != 0) {
                // $('#txtSpclDiscAmt_' + id).val('');
                selectedRow.find('[id^=txtSpclDiscAmt_]').val('');
                $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
            }
            if ($spclDiscAmt != 0) {
                //  $('#txtSpclDiscPer_' + id).val('');
                selectedRow.find('[id^=txtSpclDiscPer_]').val('');
                $('#txtBillDiscAmt,#txtBillDiscPer').val('').attr('disabled', 'disabled');
            }
            if ($spclDiscPer > 100) {
                alert('Discount Cannot be Greater than 100%');
                //  $('#txtSpclDiscPer_' + id).val('');
                selectedRow.find('[id^=txtSpclDiscPer_]').val('');
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

        $UpdateMasterVAT = function (el, id, callback) {
            var selectedRow = $(el).closest('tr');

            if (selectedRow.find('[id^=spnItemId_]').text() == "") {
                modelAlert('Please Select Item First');
                return false;
            }
            else {
                $('#chkUpdateCFVAT,#chkUpdateVAT').attr('checked', 'checked');//#cbUpdateHSNCode,#cbUpdateGSTType,
                $('#TextConversionfactorVAT').val(selectedRow.find('[id^=txtCF_]').val());
                $('#txtUpdateVATPercent').val(selectedRow.find('[id^=txtVAT_]').val());
                $('#txtUpdateVATAmt').val(selectedRow.find('[id^=txtVATAmount_]').val());
                $('#divUpdatemasterVAT').showModel();
                // $('#ddlUpdateGSTType').empty();
                //serverCall('Services/WebService.asmx/bindGSTType', callback, function (response) {
                //    var Data = $.parseJSON(response);
                //    for (var i = 0; i < Data.length; i++) {
                //        $('#ddlUpdateGSTType').append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                //    }
                //    $('#lblUpdateItemName').text(selectedRow.find('[id^=spnItemName_]').text());
                //    $('#spnUpdateRowId').text(id);
                //    $('#txtUpdateCF').val(selectedRow.find('[id^=txtCF_]').val());
                //    $('#txtUpdateHSNCode').val(selectedRow.find('[id^=txtHSNCode_]').val());
                //    if (selectedRow.find('[id^=ddlGSTType_]').val() == "T4") {
                //        $('#ddlUpdateGSTType').val("T4");
                //        $('#txtUpdateIGSTPer').removeAttr('disabled');
                //        $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').attr('disabled', 'disabled');
                //    }
                //    else if (selectedRow.find('[id^=ddlGSTType_]').val() == "T7") {
                //        $('#ddlUpdateGSTType').val("T7");
                //        $('#txtUpdateIGSTPer').attr('disabled', 'disabled');
                //        $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');

                //    }
                //    else {
                //        $('#ddlUpdateGSTType').val("T6");
                //        $('#txtUpdateIGSTPer').attr('disabled', 'disabled');
                //        $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');
                //    }
                //    $('#txtUpdateIGSTPer').val(selectedRow.find('[id^=txtIGST_]').val());
                //    $('#txtUpdateCGSTPer').val(selectedRow.find('[id^=txtCGST_]').val());
                //    $('#txtUpdateSGSTPer').val(selectedRow.find('[id^=txtSGST_]').val());
                //    if (selectedRow.find('[id^=spnIsExpirable_]').text() == "1")
                //        $('#cbUpDateIsExpirableValue').attr('checked', 'checked');
                //    else
                //        $('#cbUpDateIsExpirableValue').removeAttr('checked');
                //    $('#divUpdateItemMaster').showModel();
                //    callback(true);
                //});
            }
            callback(true);
        }


        $UpdateMaster = function (el, id, callback) {
            var selectedRow = $(el).closest('tr');

            if (selectedRow.find('[id^=spnItemId_]').text() == "") {
                modelAlert('Please Select Item First');
                return false;
            }
            else {
                $('#cbUpdateCF,#cbUpdateHSNCode,#cbUpdateGSTType,#cbUpDateIsExpirable').attr('checked', 'checked');
                $('#ddlUpdateGSTType').empty();
                //  serverCall('Services/WebService.asmx/bindGSTType', callback, function (response) {
                //var Data = $.parseJSON(response);
                //for (var i = 0; i < Data.length; i++) {
                //    $('#ddlUpdateGSTType').append($("<option></option>").attr("value", Data[i].TaxID).text(Data[i].TaxName));
                //}

                $('#ddlUpdateGSTType').bindDropDown({ data: gstPercentage, valueField: 'id', textField: 'TaxGroupLabel', isSearchable: false });

                $('#lblUpdateItemName').text(selectedRow.find('[id^=spnItemName_]').text());
                $('#spnUpdateRowId').text(id);
                $('#txtUpdateCF').val(selectedRow.find('[id^=txtCF_]').val());
                $('#txtUpdateHSNCode').val(selectedRow.find('[id^=txtHSNCode_]').val());
                //if (selectedRow.find('[id^=ddlGSTType_]').val() == "T4") {
                //    $('#ddlUpdateGSTType').val("T4");
                //    $('#txtUpdateIGSTPer').removeAttr('disabled');
                //    $('#txtUpdateSGSTPer,#txtUpdateCGSTPer,#txtUpdateUTGSTPer').attr('disabled', 'disabled');
                //}
                //else if (selectedRow.find('[id^=ddlGSTType_]').val() == "T7") {
                //    $('#ddlUpdateGSTType').val("T7");
                //    $('#txtUpdateIGSTPer,#txtUpdateSGSTPer').attr('disabled', 'disabled');
                //    $('#txtUpdateUTGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');
                //}
                //else {
                //    $('#ddlUpdateGSTType').val("T6");
                //    $('#txtUpdateIGSTPer,#txtUpdateUTGSTPer').attr('disabled', 'disabled');
                //    $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');
                //}

                $('#ddlUpdateGSTType').val(selectedRow.find('[id^=ddlGSTType_]').val());



                //if ($('#ddlUpdateGSTType').val() == "T7") {
                //    $('#txtUpdateSGSTPer').val(0);
                //    $('#txtUpdateUTGSTPer').val(selectedRow.find('[id^=txtSGST_]').val());
                //}
                //else if ($('#ddlUpdateGSTType').val() == "T6") {
                //    $('#txtUpdateUTGSTPer').val(0);
                //    $('#txtUpdateSGSTPer').val(selectedRow.find('[id^=txtSGST_]').val());
                //}
                //else {
                //    $('#txtUpdateSGSTPer,#txtUpdateUTGSTPer').val(0);
                //}

                if (selectedRow.find('[id^=spnIsExpirable_]').text() == "1")
                    $('#cbUpDateIsExpirableValue').attr('checked', 'checked');
                else
                    $('#cbUpDateIsExpirableValue').removeAttr('checked');


                $changeUpdateGSTType();

                $('#divUpdateItemMaster').showModel();
                callback(true);
                // });
            }
            callback(true);
        }

        $changeUpdateGSTType = function () {
            //if ($('#ddlUpdateGSTType').val() == "T4") {
            //    $('#txtUpdateIGSTPer').removeAttr('disabled');
            //    $('#txtUpdateSGSTPer,#txtUpdateCGSTPer,#txtUpdateUTGSTPer').attr('disabled', 'disabled');
            //}
            //else if ($('#ddlUpdateGSTType').val() == "T7") {
            //    $('#txtUpdateIGSTPer,#txtUpdateSGSTPer').attr('disabled', 'disabled');
            //    $('#txtUpdateUTGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');

            //}
            //else {
            //    $('#txtUpdateIGSTPer,#txtUpdateUTGSTPer').attr('disabled', 'disabled');
            //    $('#txtUpdateSGSTPer,#txtUpdateCGSTPer').removeAttr('disabled');
            //}
            //$('#txtUpdateIGSTPer,#txtUpdateCGSTPer,#txtUpdateSGSTPer,#txtUpdateUTGSTPer').val('0.0000');

            debugger;
            $('#txtUpdateIGSTPer').val('0.0');
            $('#txtUpdateCGSTPer').val('0.0');
            $('#txtUpdateUTGSTPer').val('0.0');
            $('#txtUpdateSGSTPer').val('0.0');

            var ID = $('#ddlUpdateGSTType').val();
            var filterGST = gstPercentage.filter(function (i) { return i.id == ID });

            if (filterGST[0].TaxGroup.toUpperCase() == 'IGST') {
                $("#txtUpdateIGSTPer").val(filterGST[0].IGSTPer);

            } else if (filterGST[0].TaxGroup.toUpperCase() == 'CGST&SGST') {
                $("#txtUpdateCGSTPer").val(filterGST[0].CGSTPer);
                $("#txtUpdateSGSTPer").val(filterGST[0].SGSTPer);
            }
            else {
                $("#txtUpdateCGSTPer").val(filterGST[0].CGSTPer);
                $("#txtUpdateUTGSTPer").val(filterGST[0].UTGSTPer);
            }

        }

        //$BindUpdates = function () { 
        //    var ID = $('#spnUpdateRowId').text();
        //    alert($('#tb_ItemsList tbody').find('#tr_' + ID).find('#spnItemId_').text());
        //}
        $BindUpdates = function () {
            $rowId = $('#spnUpdateRowId').text();
            $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateCF_').text('0');
            $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateHSNCode_').text('0');
            $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateGST_').text('0');
            $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateExpirable_').text('0');

            //$('#spnIsUpdateCF_' + $rowId + ',#spnIsUpdateHSNCode_' + $rowId + ',#spnIsUpdateGST_' + $rowId + ',#spnIsUpdateExpirable_' + $rowId).text('0');

            $CF = 1;
            //$CGSTPer = 0.0000;
            //$SGSTPer = 0.0000;
            //$IGSTPer = 0.0000;
            //$UTGSTPer = 0.000;
            if ($('#txtUpdateCF').val() != "")
                $CF = parseFloat($('#txtUpdateCF').val());
            //if ($('#txtUpdateCGSTPer').val() != "")
            //    $CGSTPer = parseFloat($('#txtUpdateCGSTPer').val());
            //if ($('#txtUpdateSGSTPer').val() != "")
            //    $SGSTPer = parseFloat($('#txtUpdateSGSTPer').val());
            //if ($('#txtUpdateIGSTPer').val() != "")
            //    $IGSTPer = parseFloat($('#txtUpdateIGSTPer').val());
            //if ($('#txtUpdateUTGSTPer').val() != "")
            //    $UTGSTPer = parseFloat($('#txtUpdateUTGSTPer').val());
            if ($('#cbUpdateCF').prop('checked') == true) {
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtCF_').val($CF);
                //$('#spnIsUpdateCF_' + $rowId).text('1');
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateCF_').text('1');
            }
            if ($('#cbUpdateHSNCode').prop('checked') == true) {
                //$('#txtHSNCode_' + $rowId).val($('#txtUpdateHSNCode').val());
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtHSNCode_').val($('#txtUpdateHSNCode').val());
                //$('#spnIsUpdateHSNCode_' + $rowId).text('1');
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateHSNCode_').text('1');
            }
            if ($('#cbUpdateGSTType').prop('checked') == true) {
                // $('#spnIsUpdateGST_' + $rowId).text('1');
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateGST_').text('1');
                //  $('#ddlGSTType_' + $rowId).val($('#ddlUpdateGSTType').val());
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#ddlGSTType_').val($('#ddlUpdateGSTType').val());
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#ddlGSTType_').change();
                // $('#txtCGST_' + $rowId).val($('#txtUpdateCGSTPer').val());
                //$('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtCGST_' + $rowId).val($('#txtUpdateCGSTPer').val());

                //// $('#txtSGST_' + $rowId).val($('#txtUpdateSGSTPer').val());
                //if ($('#ddlUpdateGSTType').val() == "T6") {
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtSGST_' + $rowId).val($('#txtUpdateSGSTPer').val());
                //}
                //else if ($('#ddlUpdateGSTType').val() == "T7") {
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtSGST_' + $rowId).val($('#txtUpdateUTGSTPer').val());
                //}
                //else { $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtSGST_' + $rowId).val(0); }

                //// $('#txtIGST_' + $rowId).val($('#txtUpdateIGSTPer').val());
                //$('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtIGST_' + $rowId).val($('#txtUpdateIGSTPer').val());

                //if ($('#ddlUpdateGSTType').val() == "T4") {
                //    // $('#txtIGST_' + $rowId).removeAttr('disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtIGST_' + $rowId).removeAttr('disabled');
                //    // $('#txtCGST_' + $rowId + ',#txtSGST_' + $rowId).attr('disabled', 'disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtCGST_' + $rowId).attr('disabled', 'disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtSGST_' + $rowId).attr('disabled', 'disabled');
                //}
                //else if ($('#ddlUpdateGSTType').val() == "T7") {
                //    // $('#txtIGST_' + $rowId).attr('disabled', 'disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtIGST_' + $rowId).attr('disabled', 'disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtCGST_' + $rowId).removeAttr('disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtSGST_' + $rowId).removeAttr('disabled');
                //    //  $('#txtCGST_' + $rowId + ',#txtSGST_' + $rowId).removeAttr('disabled');

                //}
                //else {
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtIGST_' + $rowId).attr('disabled', 'disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtCGST_' + $rowId).removeAttr('disabled');
                //    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtSGST_' + $rowId).removeAttr('disabled');
                //    // $('#txtIGST_' + $rowId).attr('disabled', 'disabled');
                //    // $('#txtCGST_' + $rowId + ',#txtSGST_' + $rowId).removeAttr('disabled');
                //}

            }
            if ($('#cbUpDateIsExpirable').prop('checked') == true) {
                //  $('#spnIsUpdateExpirable_' + $rowId).text('1');
                $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsUpdateExpirable_').text('1');
                if ($('#cbUpDateIsExpirableValue').prop('checked') == true) {
                    //$('#txtExp_' + $rowId).val('').removeAttr('disabled');
                    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtExp_').removeAttr('disabled');
                    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsExpirable_').text('1');
                    // $('#spnIsExpirable_' + $rowId).text('1');

                }
                else {
                    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#txtExp_').attr('disabled', 'disabled');
                    $('#tb_ItemsList tbody').find('#tr_' + $rowId).find('#spnIsExpirable_').text('0');
                    // $('#txtExp_' + $rowId).val('').attr('disabled', 'disabled');
                    //$('#spnIsExpirable_' + $rowId).text('0');

                }
            }
            $('#divUpdateItemMaster').hide();
        }

        $UpdateFinalDiscount = function (callback) {
            $('#tb_ItemsList tbody tr').each(function () {
                // $rowid = $(this).closest('tr').attr('id').split('_')[1];
                $getTaxCalculations(this, function () { });
            });
            callback(true);
        }


        var addNewItemRow = function (IsFree, storeType, callback) {
            var requiredClass = '';
            if (storeType == 'STO00001')
                requiredClass = 'requiredField';



            var tableBody = $('#tb_ItemsList tbody');
            var id = (tableBody.find('tr').length + 1);
            var tableRow = $('<tr id="tr_' + id + '" tableID=' + id + ' />');//
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
            tableRow.append('<td class="GridViewItemStyle"  style="width:200px" ><input type="text" id="txtItemName_" tabindex="' + (id * 100 + 1) + '" class="requiredField" autocomplete="off" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtCF_" tabindex="' + (id * 100 + 2) + '"  class="requiredField" autocomplete="off"   onlynumber="10" decimalplace="4" max-value="1000"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
            tableRow.append('<td class="GridViewItemStyle"><span id="spnPurchaseSalesUnit_"></span></td>');
            tableRow.append('<td class="GridViewItemStyle"><select id="ddlTaxCalOn_"  tabindex="' + (id * 100 + 4) + '" onchange="$getTaxCalculations(,function(){});" disabled ></select></td>');
            tableRow.append('<td class="GridViewItemStyle" style="display:none"><input type="text" id="txtDeal1_"  tabindex="' + (id * 100 + 5) + '" maxlength="10" decimalplace="4" style="width:37%;"  onlynumber="5" decimalplace="2" max-value="100" value="0" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  />+ '
                                                        + '<input type="text" id="txtDeal2_"  tabindex="' + (id * 100 + 6) + '" maxlength="10" decimalplace="4" style="width:37%;" onlynumber="5" decimalplace="2" max-value="100" value="0" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');

            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtQty_" maxlength="10" decimalplace="4" class="requiredField" tabindex="' + (id * 100 + 7) + '" onkeyup="_onGRNAmountChange(this)"   onblur="onQuantityChange(this,function(){_enableSaveChanges(function () {});})" onlynumber="10"  max-value="1000000000" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtRate_"  tabindex="' + (id * 100 + 8) + '" maxlength="10" class="requiredField" onkeyup="_onGRNAmountChange(this)"   onblur="onRateChange(this,function(){_enableSaveChanges(function () {}); })"  onlynumber="10" decimalplace="4" max-value="1000000000" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"   /></td>');
          
            tableRow.append('<td class="GridViewItemStyle"><input type="text"  id="txtBatchNo_" maxlength="10" tabindex="' + (id * 100 + 9) + '" onkeyup="ChekDuplicateBatchNo(this)" class="batchNo ' + requiredClass + ' " /></td>');

            tableRow.append('<td class="GridViewItemStyle" style="display:none"><input type="text" id="txtMrp_" maxlength="10" tabindex="' + (id * 100 + 10) + '"     /></td>');
          
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtDiscPer_" tabindex="' + (id * 100 + 15) + '" maxlength="10" onkeyup="_onGRNAmountChange(this)"   onblur="onDiscountPercentChange(this,function(){_enableSaveChanges(function () {});})" onlynumber="7" decimalplace="4" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtDiscAmt_" tabindex="' + (id * 100 + 16) + '" maxlength="10" onkeyup="_onGRNAmountChange(this)"   onblur="onDiscountAmountChange(this,function(){_enableSaveChanges(function () {});})"  onlynumber="10" decimalplace="4" max-value="0" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');

            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtVAT_" maxlength="10" tabindex="' + (id * 100 + 11) + '" class="' + requiredClass + '" onkeyup="_onGRNAmountChange(this)" onblur="onQuantityChange(this,function(){_enableSaveChanges(function () {});})" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtVATAmount_" maxlength="10" tabindex="' + (id * 100 + 12) + '" class="' + requiredClass + '" onkeyup="_onGRNAmountChange(this)" onblur="onQuantityChange(this,function(){_enableSaveChanges(function () {});})" /></td>');
            tableRow.append('<td class="GridViewItemStyle hidden tdData"></td>');
            tableRow.append('<td class="GridViewItemStyle hidden tdTaxDetails"></td>');


            tableRow.append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtSpclDiscPer_" tabindex="' + (id * 100 + 13) + '" maxlength="10"   onblur="onSpecialDiscountChange(this)"  /></td>');
            tableRow.append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtSpclDiscAmt_"  maxlength="5"     /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtOtherCharges_" maxlength="10" tabindex="' + (id * 100 + 14) + '" class="' + requiredClass + '" disabled /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtNetAmount_" maxlength="10" tabindex="' + (id * 100 + 15) + '" class="' + requiredClass + '" disabled /></td>');

            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtExp_" maxlength="5" placeholder="mm/YY" tabindex="' + (id * 100 + 18) + '"  onkeyup="return validateExpiry(this,event);" title="Press Enter to Add New Row" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img id="btnAddFree_" title="ALT+V : Add Free Item" src="../../Images/plus_in.gif"  style="cursor:pointer" onclick="onAddFreeItem(this,' + id + ')" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img id="btnAddSameBatch_" title="ALT+B : Add Other Batch Item" src="../../Images/plus_in.gif"  style="cursor:pointer" onclick="onAddSameBatchItem(this,' + id + ')" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img class="itemAddRemove" title="ALT+N : Add New Item" id="btnAdd_" src="../../Images/plus_in.gif"  style="cursor:pointer" onclick="onAddNewRow(this)" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img src="../../Images/Post.gif" style="cursor:pointer;" onclick="$UpdateMasterVAT(this,' + id + ',function(){})" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img class="itemAddRemove" title="ALT+C : Delete Last Row" id="btnRemove_" src="../../Images/Delete.gif" onclick="removeRow(this,function(){})" style="cursor:pointer;" /></td>');

            tableRow.append('<td style="display:none;">'
                + '<span id="spnItemName_" ></span>'
                + '<span id="spnItemId_" ></span>'
                + '<span id="spnIsExpirable_"></span>'
                + '<span id="spnSubCategoryID_"></span>'
                + '<span id="spnCGSTAmt_">0</span>'
                + '<span id="spnSGSTAmt_">0</span>'
                + '<span id="spnIGSTAmt_">0</span>'
                + '<span id="spnNetAmount_">0</span>'
                + '<span id="spnDiscPer_">0</span>'
                + '<span id="spnDiscAmt_">0</span>'
                + '<span id="spnSpclDiscPer_">0</span>'
                + '<span id="spnSpclDiscAmt_">0</span>'
                + '<span id="spnGrossAmt_">0</span>'
                + '<span id="spnUnitPrice_">0</span>'
                + '<span id="spnStockId_"></span>'
                + '<span id="spnIsReturn_">0</span>'
                + '<span id="spnGRNNo_"></span>'
                + '<span id="spnInvoiceNo_"></span>'
                + '<span id="spnIsFree_">' + IsFree + '</span>'
                + '<span id="spnIsOnSellingPrice">0</span>'
                + '<span id="spnSellingMargin">0.00</span>'
                + '<span id="spnMarkUpPercent_">0</span>'
                + '<span id="spnOtherCharges_">0</span>'
                + '<span id="spnPurUnit_">0</span>'
                + '<span id="spnSalesUnit_"></span>'
                + '<span id="spnPurchaseOrderDetailID_" ledgerTnxNo="0" stockNo="0"></span>'
                + '<span id="spnSaleTaxPercent_"></span>'
                  + '<span id="spnFreeAgainstItemID_"></span>'
                  + '<span id="spnIsUpdateCF_">0</span>'
                  + '<span id="spnIsUpdateHSNCode_">0</span>'
                  + '<span id="spnIsUpdateGST_">0</span>'
                  + '<span id="spnIsUpdateExpirable_">0</span>'
                + '</td>');

            tableBody.find('tr #btnAdd_').addClass('hidden');
            tableBody.append(tableRow[0].outerHTML);
            HideSupplier();
            callback(tableBody.find('tr:last'));
        }
        else {
            tableRow.append('<td class="GridViewItemStyle"  style="width:200px;"><input type="text" id="txtItemName_" tabindex="' + (id * 100 + 1) + '" class="requiredField" autocomplete="off" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtCF_" tabindex="' + (id * 100 + 2) + '"  class="requiredField" autocomplete="off"   onlynumber="10" decimalplace="4" max-value="1000"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
            tableRow.append('<td class="GridViewItemStyle"><span id="spnPurchaseSalesUnit_"></span></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtHSNCode_" maxlength="10" autocomplete="off" tabindex="' + (id * 100 + 3) + '"></td>');
            tableRow.append('<td class="GridViewItemStyle"><select id="ddlTaxCalOn_"  tabindex="' + (id * 100 + 4) + '" onchange="$getTaxCalculations(,function(){});" disabled ></select></td>');
            tableRow.append('<td class="GridViewItemStyle" style=""><input type="text" id="txtDeal1_"  tabindex="' + (id * 100 + 5) + '" maxlength="10" decimalplace="4" style="width:38%;"  onlynumber="5" decimalplace="2" max-value="100" value="0" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  />+ '
                                                        + '<input type="text" id="txtDeal2_"  tabindex="' + (id * 100 + 6) + '" maxlength="10" decimalplace="4" style="width:38%;" onlynumber="5" decimalplace="2" max-value="100" value="0" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');

            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtQty_" maxlength="10" decimalplace="4" class="requiredField" tabindex="' + (id * 100 + 7) + '" onkeyup="return checkForSecondDecimal(this,event);"   onblur="$getTaxCalculations(this,function(){});" onlynumber="10"  max-value="1000000000" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtRate_"  tabindex="' + (id * 100 + 8) + '" maxlength="10" class="requiredField" onkeyup="return checkForSecondDecimal(this,event);"   onblur="$getTaxCalculations(this,function(){});"  onlynumber="10" decimalplace="4" max-value="1000000000" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"   /></td>');
            //tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtQty_" maxlength="10" decimalplace="4" class="requiredField" tabindex="' + (id * 100 + 8) + '" onkeyup="_onGRNAmountChange(this)"   onblur="onQuantityChange(this,function(){_enableSaveChanges(function () {});})" onlynumber="10"  max-value="1000000000" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
           

            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtBatchNo_" maxlength="10" tabindex="' + (id * 100 + 9) + '"   onkeyup="ChekDuplicateBatchNo(this)" class="batchNo ' + requiredClass + '" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtMrp_" maxlength="10" tabindex="' + (id * 100 + 10) + '" class="' + requiredClass + '" onkeyup="return checkForSecondDecimal(this,event); "     /></td>');
           
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtDiscPer_" tabindex="' + (id * 100 + 13) + '" maxlength="10" onkeyup="$ValidateDiscount(this,function(){});"   onblur="$getTaxCalculations(this,function(){});" onlynumber="7" decimalplace="4" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtDiscAmt_" tabindex="' + (id * 100 + 14) + '" maxlength="10" onkeyup="$ValidateDiscount(this,function(){});"   onblur="$getTaxCalculations(this,function(){});"  onlynumber="10" decimalplace="4" max-value="0" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtSpclDiscPer_" tabindex="' + (id * 100 + 15) + '" maxlength="10"   onkeyup="$ValidateDiscount(this,function(){});"   onblur="$getTaxCalculations(this,function(){});" onlynumber="7" decimalplace="4" max-value="100"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>');

            tableRow.append('<td class="GridViewItemStyle"><select id="ddlGSTType_" tabindex="' + (id * 100 + 16) + '" onchange="$changeTaxType(this, function () { });$getTaxCalculations(this,function(){});" ></select></td>');//
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtCGST_' + id + '" tabindex="' + (id * 100 + 17) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled"  onblur="$getTaxCalculations(this,function(){});"  /></td>');//
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtSGST_' + id + '" tabindex="' + (id * 100 + 18) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  disabled="disabled" onblur="$getTaxCalculations(this,function(){});" /></td>');//
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtIGST_' + id + '" tabindex="' + (id * 100 + 19) + '" maxlength="10" onkeypress="return checkForSecondDecimal(this,event);"  disabled="disabled" onblur="$getTaxCalculations(this,function(){});" /></td>');//

            tableRow.append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtVAT_" maxlength="10" tabindex="' + (id * 100 + 11) + '" class="' + requiredClass + '" onkeyup="_onGRNAmountChange(this)" onblur="onQuantityChange(this,function(){_enableSaveChanges(function () {});})" /></td>');
            tableRow.append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtVATAmount_" maxlength="10" tabindex="' + (id * 100 + 12) + '" class="' + requiredClass + '" onkeyup="_onGRNAmountChange(this)" onblur="onQuantityChange(this,function(){_enableSaveChanges(function () {});})" /></td>');
            tableRow.append('<td class="GridViewItemStyle hidden tdData"></td>');
            tableRow.append('<td class="GridViewItemStyle hidden tdTaxDetails"></td>');


            tableRow.append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtSpclDiscAmt_"  maxlength="5"     /></td>');
            tableRow.append('<td style="display:none;" class="GridViewItemStyle"><input type="text" id="txtOtherCharges_" maxlength="10" tabindex="' + (id * 100 + 20) + '" class="' + requiredClass + '" disabled /></td>');
            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtNetAmount_" maxlength="10" tabindex="' + (id * 100 + 21) + '" class="' + requiredClass + '" disabled /></td>');

            tableRow.append('<td class="GridViewItemStyle"><input type="text" id="txtExp_" maxlength="5" placeholder="mm/YY" tabindex="' + (id * 100 + 22) + '"  onkeyup="return validateExpiry(this,event);" title="Press Enter to Add New Row" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img id="btnAddFree_" title="ALT+V : Add Free Item" src="../../Images/plus_in.gif"  style="cursor:pointer" onclick="onAddFreeItem(this,' + id + ')" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img id="btnAddSameBatch_" title="ALT+B : Add Other Batch Item" src="../../Images/plus_in.gif"  style="cursor:pointer" onclick="onAddSameBatchItem(this,' + id + ')" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img class="itemAddRemove" title="ALT+N : Add New Item" id="btnAdd_" src="../../Images/plus_in.gif"  style="cursor:pointer" onclick="onAddNewRow(this)" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img src="../../Images/Post.gif" style="cursor:pointer;" onclick="$UpdateMaster(this,' + id + ',function(){})" /></td>');
            tableRow.append('<td class="GridViewItemStyle"><img class="itemAddRemove" title="ALT+C : Delete Last Row" id="btnRemove_" src="../../Images/Delete.gif" onclick="removeRow(this,function(){})" style="cursor:pointer;" /></td>');

            tableRow.append('<td style="display:none;">'
                + '<span id="spnItemName_" ></span>'
                + '<span id="spnItemId_" ></span>'
                + '<span id="spnIsExpirable_"></span>'
                + '<span id="spnSubCategoryID_"></span>'
                + '<span id="spnCGSTAmt_">0</span>'
                + '<span id="spnSGSTAmt_">0</span>'
                + '<span id="spnIGSTAmt_">0</span>'
                + '<span id="spnUTGSTAmt_">0</span>'
                + '<span id="spnNetAmount_">0</span>'
                + '<span id="spnDiscPer_">0</span>'
                + '<span id="spnDiscAmt_">0</span>'
                + '<span id="spnSpclDiscPer_">0</span>'
                + '<span id="spnSpclDiscAmt_">0</span>'
                + '<span id="spnGrossAmt_">0</span>'
                + '<span id="spnUnitPrice_">0</span>'
                + '<span id="spnStockId_"></span>'
                + '<span id="spnIsReturn_">0</span>'
                + '<span id="spnGRNNo_"></span>'
                + '<span id="spnInvoiceNo_"></span>'
                + '<span id="spnIsFree_">' + IsFree + '</span>'
                + '<span id="spnIsOnSellingPrice">0</span>'
                + '<span id="spnSellingMargin">0.00</span>'
                + '<span id="spnMarkUpPercent_">0</span>'
                + '<span id="spnOtherCharges_">0</span>'
                + '<span id="spnPurUnit_">0</span>'
                + '<span id="spnSalesUnit_"></span>'
                + '<span id="spnPurchaseOrderDetailID_" ledgerTnxNo="0" stockNo="0"></span>'
                + '<span id="spnSaleTaxPercent_"></span>'
                  + '<span id="spnFreeAgainstItemID_"></span>'
                   + '<span id="spnIsUpdateCF_">0</span>'
                  + '<span id="spnIsUpdateHSNCode_">0</span>'
                  + '<span id="spnIsUpdateGST_">0</span>'
                  + '<span id="spnIsUpdateExpirable_">0</span>'
                + '</td>');

            tableBody.find('tr #btnAdd_').addClass('hidden');
            tableBody.append(tableRow[0].outerHTML);
            //  $bindGSTTypee(this, function () { });//
            HideSupplier();
            callback(tableBody.find('tr:last'));
        }
    }

    var BindLastPurchaseRate = function (data, callback) {
        serverCall('../Store/Services/CommonService.asmx/GetLastPurchaseRate', data, function (response) {
            var responseData = JSON.parse(response);
            callback(responseData);
        });
    }
    var bindSelectedItemDetails = function (selectedRow, data, callback) {
        // alert(selectedRow.find('#spnFreeAgainstItemID_').text());
        if ((Number(selectedRow.find('#spnIsFree_').text()) == 1) && (selectedRow.find('#spnFreeAgainstItemID_').text() != data.item.ItemID)) {
            var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();

            var LastPurdata = {
                itemID: data.item.ItemID,
                StoreType: storeLedgerNo
            }

            BindLastPurchaseRate(LastPurdata, function (rate) {
                if (rate.length > 0) {
                    selectedRow.find('[id^=txtRate_]').val(rate[0].Rate);
                }
                else {
                    selectedRow.find('[id^=txtRate_]').val(0);
                }
            });
        }

        var venderVatType = $('#ddlVendor').val().split('#')[3];
        var query = {
            itemID: data.item.ItemID,
            vendorID: '',
            vendorVatType: venderVatType,
            itemVatType: data.item.VatType
        }

        if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                getVatTaxPercent(query, function (taxPercent) {
                    if (taxPercent.length > 0) {
                        selectedRow.find('[id^=txtItemName_]').val(data.item.label);
                        selectedRow.find('[id^=spnItemName_]').text(data.item.label);
                        selectedRow.find('[id^=spnItemId_]').text(data.item.ItemID);
                        selectedRow.find('[id^=txtCF_]').val(data.item.ConversionFactor);
                        selectedRow.find('[id^=txtVAT_]').val(taxPercent[0].VatPercentage);
                        selectedRow.find('[id^=txtHSNCode_]').val(data.item.HSNCode);
                        if (data.item.IsExpirable == 0) {
                            selectedRow.find('[id^=txtExp_]').attr('disabled', true).removeAttr('class').val();
                            selectedRow.find('[id^=spnIsExpirable_]').text(data.item.IsExpirable);
                        }
                        else {
                            selectedRow.find('[id^=txtExp_]').attr('disabled', false).addClass('required').val();
                            selectedRow.find('[id^=spnIsExpirable_]').text(data.item.IsExpirable);
                        }

                        selectedRow.find('[id^=spnSalesUnit_]').text(data.item.minorUnit);
                        selectedRow.find('[id^=spnPurUnit_]').text(data.item.majorUnit);
                        selectedRow.find('[id^=spnPurchaseSalesUnit_]').text(data.item.majorUnit + '/' + data.item.minorUnit);
                        selectedRow.find('[id^=spnSubCategoryID_]').text(data.item.SubCategoryID);
                        selectedRow.find('[id^=spnSaleTaxPercent_]').text(data.item.DefaultSaleVatPercentage);
                        selectedRow.find('.tdData').text(JSON.stringify(data.item));
                    }
                    else {
                        modelAlert('VAT Not Found.');
                    }

                    HideSupplier();
                });
            }
            else {

                debugger;

                selectedRow.find('[id^=txtItemName_]').val(data.item.label);
                selectedRow.find('[id^=spnItemName_]').text(data.item.label);
                selectedRow.find('[id^=spnItemId_]').text(data.item.ItemID);
                selectedRow.find('[id^=txtCF_]').val(data.item.ConversionFactor);
                // selectedRow.find('[id^=txtVAT_]').val(taxPercent[0].VatPercentage);
                selectedRow.find('[id^=txtHSNCode_]').val(data.item.HSNCode);
                if (data.item.IsExpirable == 0) {
                    selectedRow.find('[id^=txtExp_]').attr('disabled', true).removeAttr('class').val();
                    selectedRow.find('[id^=spnIsExpirable_]').text(data.item.IsExpirable);
                }
                else {
                    selectedRow.find('[id^=txtExp_]').attr('disabled', false).addClass('required').val();
                    selectedRow.find('[id^=spnIsExpirable_]').text(data.item.IsExpirable);
                }

                var isfree = 0;
                isfree = selectedRow.find('[id^=spnIsFree_]').text();
                //dsk

                debugger;
                // selectedRow.find('[id^=ddlGSTType_]').val(data.item.GSTTypeNew);
                selectedRow.find("[id^=ddlGSTType_] option:contains('" + data.item.GSTTypeNew + "')").attr('selected', true);

                //if (isfree == 0) {
                //    if (data.item.GSTType == "IGST") {//
                //        selectedRow.find('[id^=ddlGSTType_]').val("T4");
                //        //selectedRow.find('[id^=txtIGST_]').attr('disabled', false);
                //        //selectedRow.find('[id^=txtCGST_]').attr('disabled', true);
                //        //selectedRow.find('[id^=txtSGST_]').attr('disabled', true);
                //    }
                //    else if (data.item.GSTType == "CGST&UTGST") {//
                //        selectedRow.find('[id^=ddlGSTType_]').val("T7");
                //        //selectedRow.find('[id^=txtIGST_]').attr('disabled', true);
                //        //selectedRow.find('[id^=txtCGST_]').attr('disabled', false);
                //        //selectedRow.find('[id^=txtSGST_]').attr('disabled', false);
                //    }
                //    else {//
                //        selectedRow.find('[id^=ddlGSTType_]').val("T6");
                //        //selectedRow.find('[id^=txtIGST_]').attr('disabled', true);
                //        //selectedRow.find('[id^=txtCGST_]').attr('disabled', false);
                //        //selectedRow.find('[id^=txtSGST_]').attr('disabled', false);
                //    }
                //}

                selectedRow.find('[id^=spnSalesUnit_]').text(data.item.minorUnit);
                selectedRow.find('[id^=spnPurUnit_]').text(data.item.majorUnit);
                selectedRow.find('[id^=spnPurchaseSalesUnit_]').text(data.item.majorUnit + '/' + data.item.minorUnit);
                selectedRow.find('[id^=spnSubCategoryID_]').text(data.item.SubCategoryID);
                selectedRow.find('[id^=spnSaleTaxPercent_]').text(data.item.DefaultSaleVatPercentage);
                selectedRow.find('.tdData').text(JSON.stringify(data.item));

                //if (isfree == 0) {
                //    //selectedRow.find('[id^=txtIGST_]').val(data.item.IGSTPercent);//
                //    //selectedRow.find('[id^=txtCGST_]').val(data.item.CGSTPercent);//
                //    //selectedRow.find('[id^=txtSGST_]').val(data.item.SGSTPercent);//

                //    selectedRow.find('[id^=txtRate_]').val("");//
                //    selectedRow.find('[id^=txtQty_]').val("");//
                //    selectedRow.find('[id^=txtMrp_]').val("");//
                //    selectedRow.find('[id^=txtBatchNo_]').val("");//
                //}

                //selectedRow.find('[id^=spnCGSTAmt_]').text(0);//
                //selectedRow.find('[id^=spnSGSTAmt_]').text(0);//
                //selectedRow.find('[id^=spnIGSTAmt_]').text(0);//
                //selectedRow.find('[id^=spnUTGSTAmt_]').text(0);//


                selectedRow.find('[id^=ddlGSTType_]').change();
                $UpdateAmounts(function () { });

                HideSupplier();
            }
        }

        var HideSupplier = function () {
            var IsHide = false;
            $('#tb_ItemsList tbody').find('tr').each(function (i, r) {
                selectedRow = $(r);
                var ItemId = $.trim(selectedRow.find('[id^=spnItemId_]').text());
                //var Rate = Number(selectedRow.find('[id^=txtRate_]').val())

                if (ItemId.length > 0) {
                    IsHide = true;
                    //onRateChange(selectedRow.find('[id^=txtRate_]'), function () { });
                }
            });
            if (IsHide) {
                $('#ddlVendor').attr("disabled", true);
                $('#rbtIsConsignment').find('input[type=radio]').attr("disabled", true);
                $('#ddlVendor').trigger("chosen:updated");
            }
            else {
                $('#ddlVendor').attr("disabled", false);
                $('#rbtIsConsignment').find('input[type=radio]').attr("disabled", false);
                $('#ddlVendor').trigger("chosen:updated");
            }
        }

        var getVatTaxPercent = function (data, callback) {
            serverCall('../Store/Services/CommonService.asmx/GetVatTaxPercent', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length < 1) {
                    responseData = [{ VatPercentage: 0 }];
                    modelAlert('Vat Not Found.', function () {
                        callback(responseData);
                    });
                }
                else
                    callback(responseData);
            });
        }








        var onRateChange = function (el, callback) {
            var selectedRow = $(el).closest('tr');
            var tdData = JSON.parse(selectedRow.find('.tdData').text());




            if (el.id == 'txtRate_') {
                //   debugger;
                var rate = Number(el.value);
                var maxToleranceRate = precise_round(Number(tdData.RateDisplay + (tdData.RateDisplay * tdData.Maximum_Tolerance_Rate / 100)), 4);
                var minToleranceRate = precise_round(Number(tdData.RateDisplay - (tdData.RateDisplay * tdData.Minimum_Tolerance_Rate / 100)), 4);
                if (rate > maxToleranceRate) {
                    modelAlert('<span class="patientInfo">Max Tolerance Rate Is: ' + maxToleranceRate + '</span>', function () {
                        el.value = tdData.RateDisplay;
                        _onRateChange(selectedRow, function () {
                            callback();
                        });
                    });
                }
                else if (rate < minToleranceRate) {
                    modelAlert('<span class="patientInfo">Min Tolerance Rate Is: ' + minToleranceRate + '</span>', function () {
                        el.value = tdData.RateDisplay;
                        _onRateChange(selectedRow, function () {
                            callback();
                        });
                    });
                }
                else {
                    _onRateChange(selectedRow, function () {
                        callback();
                    });
                }
            }
            else {
                _onRateChange(selectedRow, function () {
                    callback();
                });
            }





            //getTaxCalculationDetails(selectedRow, function (data) {
            //    selectedRow.find('[id^=txtDiscAmt_]').attr('max-value', data.netAmount);
            //    data.MRP = 0;
            //    getTaxAmount(data, 0, function (t) {
            //        var netAmount = t.netAmount;
            //        if (data.IsFree > 0) {
            //            t.taxAmount = 0;
            //            t.netAmount = 0;
            //            data.otherCharges = 0;
            //        }
            //        selectedRow.find('[id^=txtVATAmount_]').val(t.taxAmount);
            //        selectedRow.find('[id^=txtNetAmount_]').val(t.netAmount);
            //        selectedRow.find('[id^=spnNetAmount_]').text(t.netAmount);
            //        selectedRow.find('.tdTaxDetails').text(JSON.stringify(t));
            //        calculateDiscountAmount(selectedRow, data.netAmount, data.DiscPer);
            //        calculateGRNSummary(function (d) {
            //            //var netAmount = Number(selectedRow.find('[id^=txtNetAmount_]').val());
            //            var itemMRP = calculateItemMRP({
            //                rate: data.Rate,
            //                quantity: data.Quantity,
            //                totalOrderAmount: d.totalGrossAmountWithTaxAndOtherCharges,
            //                otherCharges: data.otherCharges,
            //                markUpPercent: '',
            //                subCategoryID: data.subCategoryID,
            //                centerWiseMarkUp: centerWiseMarkUp,
            //                netAmount: netAmount

            //            });
            //            selectedRow.find('[id^=spnMarkUpPercent_]').text(itemMRP.markUpPercent);
            //            selectedRow.find('[id^=txtMrp_]').val(itemMRP.MRP);
            //            callback();
            //        });
            //        console.log(t);
            //    });
            //});

        }



        var _onRateChange = function (selectedRow, callback) {
            getTaxCalculationDetails(selectedRow, function (data) {
                selectedRow.find('[id^=txtDiscAmt_]').attr('max-value', data.netAmount);
                data.MRP = 0;
                getTaxAmount(data, 0, function (t) {
                    var netAmount = t.netAmount;
                    if (data.IsFree > 0) {
                        t.taxAmount = 0;
                        t.netAmount = 0;
                        data.otherCharges = 0;
                    }
                    selectedRow.find('[id^=txtVATAmount_]').val(t.taxAmount);
                    selectedRow.find('[id^=txtNetAmount_]').val(t.netAmount);
                    selectedRow.find('[id^=spnNetAmount_]').text(t.netAmount);
                    selectedRow.find('.tdTaxDetails').text(JSON.stringify(t));
                    calculateDiscountAmount(selectedRow, data.netAmount, data.DiscPer);
                    calculateGRNSummary(function (d) {
                        //var netAmount = Number(selectedRow.find('[id^=txtNetAmount_]').val());
                        var itemID = selectedRow.find('[id^=spnItemId_]').text();

                        if (Number('<%=Resources.Resource.IsGSTApplicable%>') == 0) {
                            var itemMRP = calculateItemMRP({
                                rate: data.Rate,
                                quantity: data.Quantity,
                                totalOrderAmount: d.totalGrossAmountWithTaxAndOtherCharges,
                                otherCharges: data.otherCharges,
                                markUpPercent: '',
                                subCategoryID: data.subCategoryID,
                                centerWiseMarkUp: centerWiseMarkUp,
                                netAmount: netAmount,
                                itemId: itemID

                            });
                            debugger;
                            selectedRow.find('[id^=spnMarkUpPercent_]').text(itemMRP.markUpPercent);
                            selectedRow.find('[id^=txtMrp_]').val(itemMRP.MRP);
                        }
                        callback();
                    });
                    console.log(t);
                });
            });
        }


        var onQuantityChange = function (el, callback) {
            var selectedRow = $(el).closest('tr');
            var tdData = JSON.parse(selectedRow.find('.tdData').text());


            if (el.id == 'txtQty_') {

                var quantity = Number(el.value);
                var maxToleranceQuantity = precise_round(Number(tdData.RemainQty + (tdData.InitialCount * tdData.Maximum_Tolerance_Qty / 100)), 4);
                if (quantity > maxToleranceQuantity) {
                    modelAlert('<span class="patientInfo">Max Tolerance Quantity Is: ' + maxToleranceQuantity + '</span>', function () {
                        el.value = tdData.RemainQty;
                        onRateChange(el, function () {
                            onOtherChargesChange($('#txtOtherCharges'));
                        });
                        callback();
                    });
                } else {
                    onRateChange(el, function () {
                        onOtherChargesChange($('#txtOtherCharges'));
                    });
                    callback();
                }
            }
            else {
                onRateChange(el, function () {
                    onOtherChargesChange($('#txtOtherCharges'));
                });
                callback();
            }
            //getTaxCalculationDetails(selectedRow, function (data) {
            //    calculateDiscountAmount(selectedRow, data.netAmount, data.DiscPer);
            //    calculateGRNSummary(function () { });
            //});

        }


        var onDealChange = function (el) {
            onRateChange(el, function () {
                onOtherChargesChange($('#txtOtherCharges'));

            });
            // calculateGRNSummary(function () { });
        }


        var onDiscountPercentChange = function (el, callback) {
            onRateChange(el, function () {
                onOtherChargesChange($('#txtOtherCharges'));
                callback();
            });
            //var selectedRow = $(el).closest('tr');
            //getTaxCalculationDetails(selectedRow, function (data) {
            //    calculateDiscountAmount(selectedRow, data.netAmount, data.DiscPer);
            //    onRateChange(el);
            //   // calculateGRNSummary(function () { });

            //});

        }


        var onDiscountAmountChange = function (el, callback) {
            var selectedRow = $(el).closest('tr');
            getTaxCalculationDetails(selectedRow, function (data) {
                var discountPercent = 0;
                if (data.netAmount > 0)
                    discountPercent = precise_round(((100 * data.DiscAmt) / data.netAmount), 4);

                selectedRow.find('[id^=txtDiscPer_]').val(discountPercent);
                onRateChange(el, function () {
                    onOtherChargesChange($('#txtOtherCharges'));
                    callback();
                });
                // calculateGRNSummary(function () { });
            });
        }

        var onSpecialDiscountChange = function (el) {
            onRateChange(el, function () {
                onOtherChargesChange($('#txtOtherCharges'));
            });
            //calculateGRNSummary(function () { });
        }


        var onTotalDiscountPercentChange = function (el) {
            var totalDiscountPercent = Number(el.value);
            if (totalDiscountPercent > 0)
                $(el).attr('discountOnTotal', 1);
            else
                $(el).attr('discountOnTotal', 1);


            var tableBody = $('#tb_ItemsList tbody');
            tableBody.find('tr').each(function (i, r) {
                selectedRow = $(r);
                var isFree = Number(selectedRow.find('[id^=spnIsFree_]').text());
                if (isFree == 0) {
                    selectedRow.find('[id^=txtDiscPer_]').val(totalDiscountPercent).attr('disabled', (totalDiscountPercent > 0));
                    selectedRow.find('[id^=txtDiscAmt_]').attr('disabled', (totalDiscountPercent > 0));
                    getTaxCalculationDetails(selectedRow, function (data) {
                        calculateDiscountAmount(selectedRow, data.netAmount, data.DiscPer);
                        onRateChange(selectedRow.find('[id^=txtDiscAmt_]'), function () {
                            onOtherChargesChange($('#txtOtherCharges'));
                            _enableSaveChanges(function () { });
                        });
                    });
                }
            });

        }

        var onTotalDiscountAmountChange = function (el) {
            var totalBillDiscountAmount = Number(el.value);
            if (totalBillDiscountAmount > 0) {
                var grossBillAmount = Number($('#txtBillGrossAmt').val());
                var totalBillPercent = ((100 * totalBillDiscountAmount) / grossBillAmount);

                $('#txtBillDiscPer').val(precise_round(totalBillPercent, 4));
                onTotalDiscountPercentChange($('#txtBillDiscPer')[0]);
            }
        }




        var onOtherChargesChange = function (el, callback) {
            var otherChargesAmount = Number(el.value);
            calculateGRNSummary(function (d) {
                $('#tb_ItemsList tbody tr').each(function () {
                    var selectedRow = $(this);
                    getTaxCalculationDetails(selectedRow, function (data) {
                        var netAmount = Number(selectedRow.find('[id^=txtNetAmount_]').val());
                        var itemID = selectedRow.find('[id^=spnItemId_]').text();
                        if (!data.IsFree) {
                            if (Number('<%=Resources.Resource.IsGSTApplicable%>') == 0) {
                            var itemMRP = calculateItemMRP({
                                rate: data.Rate,
                                quantity: data.Quantity,
                                totalOrderAmount: d.totalGrossAmountWithTaxAndOtherCharges,
                                otherCharges: data.otherCharges,
                                markUpPercent: '',
                                subCategoryID: data.subCategoryID,
                                centerWiseMarkUp: centerWiseMarkUp,
                                netAmount: netAmount,
                                itemId: itemID
                            });
                            debugger
                            selectedRow.find('[id^=txtMrp_]').val(itemMRP.MRP);
                            selectedRow.find('[id^=spnMarkUpPercent_]').text(itemMRP.markUpPercent);
                        }
                    }
                    });
                });

            });
        }



    var calculateDiscountAmount = function (selectedRow, netAmount, discountPercent) {
        var discountAmount = 0;
        if (netAmount > 0)
            discountAmount = precise_round(((netAmount * discountPercent) / 100), 4);

        selectedRow.find('[id^=txtDiscAmt_]').val(discountAmount);
    }

    //var calculateItemMRP = function (data) {
    //    var rate = data.rate;
    //    var quantity = data.quantity;
    //    var totalOrderAmount = data.totalOrderAmount;
    //    var otherCharges = data.otherCharges;
    //    var markUpPercent = data.markUpPercent;
    //    var netAmount = data.netAmount;
    //    if (String.isNullOrEmpty(markUpPercent)) {
    //        var filterMarkup = [];
    //        for (var j = 0; j < data.centerWiseMarkUp.length; j++) {
    //            if (data.centerWiseMarkUp[j].SubCategoryID == data.subCategoryID) {
    //                if (data.rate <= data.centerWiseMarkUp[j].ToRate) {
    //                    filterMarkup.push(data.centerWiseMarkUp[j]);
    //                    break;
    //                }
    //            }
    //        }
    //    }

    //    if (filterMarkup.length > 0)
    //        markUpPercent = filterMarkup[0].MarkUpPercentage;

    //    if (markUpPercent <= 0) {
    //        modelAlert('Mark Up Percentage Not Found.');
    //        return 0;
    //    }


    //    //  var itemMRP = precise_round((((((rate * quantity) / totalOrderAmount) * otherCharges) + rate * markUpPercent) / quantity), 4);
    //    var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);
    //    return { MRP: isNaN(itemMRP) ? 0 : itemMRP, markUpPercent: markUpPercent };
    //}
    var calculateItemMRP = function (data) {
        debugger;
        var rate = data.rate;
        var quantity = data.quantity;
        var totalOrderAmount = data.totalOrderAmount;
        var otherCharges = data.otherCharges;
        var markUpPercent = data.markUpPercent;
        var netAmount = data.netAmount;
        if (String.isNullOrEmpty(markUpPercent)) {
            var filterMarkup = [];
            var filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.ItemID == data.itemId && i.MarkUpType == "CentreWiseItemWise" });
            if (filterMarkup.length == 0)
                filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.ItemID == data.itemId && i.MarkUpType == "UniversalItemWise" });
            if (filterMarkup.length == 0)
                filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.SubCategoryID == data.subCategoryID && i.MarkUpType == "UniversalSubCategoryWise" && i.ToRate >= data.rate });


            //for (var j = 0; j < data.centerWiseMarkUp.length; j++) {
            //    if (data.centerWiseMarkUp[j].SubCategoryID == data.subCategoryID || data.centerWiseMarkUp[j].ItemID == data.itemId) {
            //         if (data.rate <= data.centerWiseMarkUp[j].ToRate) {
            //            filterMarkup.push(data.centerWiseMarkUp[j]);
            //            break;
            //        }
            //    }
            //}
        }

        //if (filterMarkup.length > 0)
        //    markUpPercent = filterMarkup[0].MarkUpPercentage;

        //if (markUpPercent <= 0) {
        //    modelAlert('Mark Up Percentage Not Found.');
        //    return 0;
        //}


        //  var itemMRP = precise_round((((((rate * quantity) / totalOrderAmount) * otherCharges) + rate * markUpPercent) / quantity), 4);
        var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);
        return { MRP: isNaN(itemMRP) ? 0 : itemMRP, markUpPercent: markUpPercent };
    }

    //var calculateItemMRP = function (data) {
    //   // debugger;
    //        markUpData = {
    //            itemID: data.itemId,
    //            subCategoryID: data.subCategoryID,
    //            rate: data.rate
    //        }
    //        var rate = data.rate;
    //        var quantity = data.quantity;
    //        var totalOrderAmount = data.totalOrderAmount;
    //        var otherCharges = data.otherCharges;
    //        var markUpPercent = data.markUpPercent;
    //        var netAmount = data.netAmount;

    //        markUpPercent = 10;
    //        var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);
    //        return { MRP: isNaN(itemMRP) ? 0 : itemMRP, markUpPercent: markUpPercent };

    //        serverCall('../Store/Services/CommonService.asmx/GetPurchaseMarkUpPercentNew', markUpData, function (response) {
    //            var rate = data.rate;
    //            var quantity = data.quantity;
    //            var totalOrderAmount = data.totalOrderAmount;
    //            var otherCharges = data.otherCharges;
    //            var markUpPercent = data.markUpPercent;
    //            var netAmount = data.netAmount;

    //            if (String.isNullOrEmpty(markUpPercent))
    //                markUpPercent = response;

    //            if (Number(markUpPercent) <= 0) {
    //                modelAlert('Mark Up Percentage Not Found.');
    //                return 0;
    //            }
    //            debugger;
    //            var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);
    //            return { MRP: isNaN(itemMRP) ? 0 : itemMRP, markUpPercent: markUpPercent };

    //        });
    //}

    var getTaxAmount = function (d, taxGroupID, callback) {
        serverCall('../Store/Services/CommonService.asmx/CalculateTaxAmount', { taxCalculationOn: d, taxGroupID: taxGroupID }, function (response) {
            var responseData = JSON.parse(response);
            callback(responseData);
        });
    }


    var getTaxCalculationDetails = function (selectedRow, callback) {
        var data = {
            Rate: Number(selectedRow.find('[id^=txtRate_]').val()),
            ActualRate: Number(selectedRow.find('[id^=txtRate_]').val()),
            MRP: Number(selectedRow.find('[id^=txtMrp_]').val()),
            deal: Number(selectedRow.find('[id^=txtDeal1_]').val()),
            deal2: Number(selectedRow.find('[id^=txtDeal2_]').val()),
            DiscPer: Number(selectedRow.find('[id^=txtDiscPer_]').val()),
            DiscAmt: Number(selectedRow.find('[id^=txtDiscAmt_]').val()),
            Type: (selectedRow.find('[id^=ddlTaxCalOn_]').val()),
            Quantity: Number(selectedRow.find('[id^=txtQty_]').val()),
            TaxPer: Number(selectedRow.find('[id^=txtVAT_]').val()),
            subCategoryID: selectedRow.find('[id^=spnSubCategoryID_]').text(),
            otherCharges: Number($('[id^=txtOtherCharges]').val()),
            IsFree: Number(selectedRow.find('[id^=spnIsFree_]').text()),
        }
        data.netAmount = precise_round((data.Rate * data.Quantity), 4);
        callback(data)
    }






    var calculateGRNSummary = function (callback) {
        var dataSummary = {};
        dataSummary.otherCharges = Number($('#txtOtherCharges').val());
        dataSummary.netAmountWithOutTax = 0;
        dataSummary.totalGrossAmount = 0;
        dataSummary.totalGrossAmountWithTax = 0;
        dataSummary.taxAmount = 0;
        dataSummary.discountAmount = 0;
        dataSummary.netAmount = 0;
        dataSummary.totalGrossAmountWithTaxAndOtherCharges = 0;

        $('#tb_ItemsList tbody tr').each(function () {
            var selectedRow = $(this);
            var isFree = Number(selectedRow.find('[id^=spnIsFree_]').text());
            var rate = Number((selectedRow).find('[id^=txtRate_]').val());
            var quantity = Number((selectedRow).find('[id^=txtQty_]').val());
            var RowData = $(selectedRow).find('.tdTaxDetails').text();
            var taxableData = "";
            if (RowData.length > 0)
                taxableData = JSON.parse(RowData);

            if (isFree == 0)
                dataSummary.netAmountWithOutTax += (rate * quantity);

            dataSummary.totalGrossAmount += (rate * quantity);
            dataSummary.totalGrossAmountWithTax += Number(taxableData.netAmount);
        });





        $('#tb_ItemsList tbody tr').each(function () {
            var selectedRow = this;
            var rate = Number($(selectedRow).find('[id^=txtRate_]').val());
            var quantity = Number(($(selectedRow).find('[id^=txtQty_]').val()));
            //  var taxableData = JSON.parse($(selectedRow).find('.tdTaxDetails').text());

            var RowData = $(selectedRow).find('.tdTaxDetails').text();
            var taxableData = "";
            if (RowData.length > 0)
                taxableData = JSON.parse(RowData);

            var otherChargesAmount = 0;
            if (taxableData.netAmount > 0) {
                var otherChargesPercent = ((100 * (taxableData.netAmount)) / dataSummary.totalGrossAmountWithTax);
                otherChargesAmount = ((dataSummary.otherCharges * otherChargesPercent) / 100);
            }

            var netAmount = Number($(selectedRow).find('[id^=spnNetAmount_]').text());
            var netAmountWithOtherCharges = precise_round((netAmount + otherChargesAmount), 4);
            dataSummary.totalGrossAmountWithTaxAndOtherCharges += netAmountWithOtherCharges;
            $(selectedRow).find('[id^=txtNetAmount_]').val(netAmountWithOtherCharges);
            $(selectedRow).find('[id^=txtOtherCharges_]').val(precise_round(otherChargesAmount, 4));
            dataSummary.taxAmount += Number($(selectedRow).find('[id^=txtVATAmount_]').val());
            dataSummary.discountAmount += Number($(selectedRow).find('[id^=txtDiscAmt_]').val());
        });



        $('#tb_ItemsList tbody tr').each(function () {
            var selectedRow = this;

            var netAmount = Number($(selectedRow).find('[id^=txtNetAmount_]').val());
            dataSummary.netAmount += netAmount;
        });




        $('#txtBillGrossAmt').val(precise_round(dataSummary.netAmountWithOutTax, 4));
        $('#txtVATAmount').val(precise_round(dataSummary.taxAmount, 4));
        $('#txtInvoiceAmount').val(precise_round(dataSummary.netAmount, 4));
        $('#txtTotalDiscount').val(precise_round(dataSummary.discountAmount, 4));


        //if (dataSummary.netAmountWithOutTax > 0)
        //    disableBillInvoiceDetails(true);
        //else
        //    disableBillInvoiceDetails(false);


        var isDiscountOnTotal = Number($('#txtBillDiscPer').attr('discountOnTotal'));

        if (dataSummary.discountAmount > 0) {
            if (isDiscountOnTotal < 1)
                $('#txtBillDiscPer,#txtBillDiscAmt').val('').prop('disabled', true);
        }
        else
            $('#txtBillDiscPer,#txtBillDiscAmt').val('').prop('disabled', false);


        callback(dataSummary);

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
                    modelAlert('Invalid Month');
                    $(sender).val('').focus();
                }
            }
            if (strVal.length == 2 && charCode != 8 && strVal.charAt(1) != '/')
                $(sender).val(strVal + '/');

            if (strVal.charAt(3) == '/' && charCode != 8)
                $(sender).val(strVal.substring(0, 3));

            if (strVal.length == 5 && charCode != 8) {
                if (parseFloat(strVal.split('/')[1]) < parseFloat($.datepicker.formatDate('y', new Date()))) {
                    modelAlert('Expiry Date Cannot be less than Current Date');
                    $(sender).val('').focus();
                }
                else {
                    if ((parseFloat(strVal.split('/')[1]) == parseFloat($.datepicker.formatDate('y', new Date()))) && (parseFloat(strVal.split('/')[0]) < parseFloat($.datepicker.formatDate('mm', new Date(new Date().getTime() + 24 * 60 * 60 * 1000))))) {
                        modelAlert('Expiry Date Cannot be less than Current Date');
                        $(sender).val('').focus();
                    }

                }
            }

        }
    }

    var validateControls = function (callback, selectedRow) {
        var grnType = ($('#ddlVendor').val());
        var billNumber = $.trim($('#txtBillNo').val());
        var billDate = $.trim($('#txtBillNo').val());
        var challanNumber = $.trim($('#txtChallanNo').val());
        var challanDate = $.trim($('#txtChallanDate').val());
        var _txtItemName = selectedRow.find('[id^=txtItemName_]');

        if (grnType == 0) {
            modelAlert('Please Select Supplier.', function () {
                _txtItemName.val('');
            });
            return false;
        }
        if (grnType == 0 || grnType == 3) {
            if (String.isNullOrEmpty(billNumber)) {
                modelAlert('Please Enter Invoice No.', function () {
                    _txtItemName.val('');
                });
                return false;
            }
            if (String.isNullOrEmpty(billDate)) {
                modelAlert('Please Select Invoice Date.', function () {
                    _txtItemName.val('');
                });
                return false;
            }
        }
        if (grnType == 1 || grnType == 3) {
            if (String.isNullOrEmpty(challanNumber)) {
                modelAlert('Please Enter Challan No.', function () {
                    _txtItemName.val('');
                });
                return false;
            }
            if (String.isNullOrEmpty(challanDate)) {
                modelAlert('Please Select Challan Date.', function () {
                    _txtItemName.val('');
                });
                return false;
            }
        }

        callback();

    }


    var disableBillInvoiceDetails = function (status) {
        var _divOrderDetails = $('#divOrderDetails');
        _divOrderDetails.find('input[type=text]').prop('disabled', status);
        _divOrderDetails.find('input[type=radio]').prop('disabled', status);
        _divOrderDetails.find('select').prop('disabled', status).trigger('chosen:updated');
        _divOrderDetails.find('#txtOtherCharges').prop('disabled', false);
    }





    //$checkDuplicateInvoice = function (callback) {
    //    serverCall('Services/WebService.asmx/checkDuplicateInvoice', { VendorLedgerNo: $('#ddlVendor').val().split('#')[0], InvoiceNo: $('#txtBillNo').val(), ChallanNo: $('#txtChallanNo').val(), Type: $('#ddlGRNType option:selected').text() }, function (response) {
    //        if (response == "1")
    //            modelAlert('Invoice No. Already Exist');

    //        if (response == "2")
    //            modelAlert('Challan No. Already Exist');

    //        if (response == "0")
    //            callback(false);

    //    });

    //}


    $SaveGRN = function (btnSave, callback) {
        validateToleranceCheck(function () {
            getGRNDetails(function (data) {
                validateGRNDetails(data, function () {
                    $(btnSave).attr('disabled', true).val('Submitting...');
                    var serviceURL = 'Services/WebService.asmx/SaveGRN';

                    var ledgerTransactionNo = Number('<%= Util.GetString(Request.QueryString["ledgerTransactionNo"]) %>');

                        if (ledgerTransactionNo > 0) {
                            serviceURL = 'Services/WebService.asmx/UpdateGRN';
                            data.ledgerTransationNo = ledgerTransactionNo;
                            data.EditGRNNo = ' <%= Util.GetString(Request.QueryString["billNo"]) %>';
                        }

                        serverCall(serviceURL, data, function (Response) {
                            var responseData = JSON.parse(Response);
                            if (responseData.status == true) {
                                var IsConsignment = Number($('input[type=radio][name$=rbtIsConsignment]:checked').val());
                                if (IsConsignment == 1) {
                                    modelAlert('Consignment Receive No. ' + responseData.response, function () {
                                        $clear();
                                    });
                                }
                                else {
                                    modelAlert(responseData.message + '<br>GRN No. ' + responseData.response, function (response) {
                                        window.open('../Store/DirectGRNReport.aspx?Hos_GRN=' + responseData.response);
                                        $clear();
                                    });
                                }
                            }
                            else {
                                $(btnSave).attr('disabled', false).val('Save');
                                modelAlert(responseData.message);
                            }
                        });
                    });
                });
            });
        }


        var getGRNDetails = function (callback) {
            var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
            var narration = $.trim($('#txtNarration').val());
            var GRNSummary = {
                VenLedgerNo: $.trim($('#ddlVendor').val().split('#')[0]),
                InvoiceNo: $('#txtBillNo').val(),
                InvoiceDate: $('#txtBillDate').val(),
                ChalanNo: $('#txtChallanNo').val(),
                ChalanDate: $('#txtChallanDate').val(),
                WayBillNo: $('#txtWayBillNo').val(),
                WayBillDate: $('#txtWayBillDate').val(),
                GatePassIn: $('#txtGatePassInWard').val(),
                NetAmount: Number($('#txtInvoiceAmount').val()),
                GrossBillAmount: Number($('#txtBillGrossAmt').val()),
                RoundOff: Number($('#txtRoundOff').val()),
                DiscAmount: Number($('#txtTotalDiscount').val()),
                StoreLedgerNo: storeLedgerNo,
                PaymentModeID: $('#rdoGRNPayType').find(':checked').val(),
                otherCharges: Number($('#txtOtherCharges').val()),
                PONumber: $.trim($('#lblPurchaseOrderNumber').text()),
                currencyCountryID: Number($('#ddlCurrency').val()),
                currency: $('#ddlCurrency option:selected').text(),
                CurrencyFactor: $('#txtCurrencyFactor').val(),
                FreightCharge: $('#txtFreight').val()
            }


            var GRNItemDetails = [];
            $('#tb_ItemsList tbody tr').each(function () {
                var selectedRow = $(this);

                var itemDetails = selectedRow.find('.tdData').text();
                if (String.isNullOrEmpty(itemDetails)) {
                    modelAlert('Please Select Items.');
                    return false;
                }

                itemDetails = JSON.parse(itemDetails);
                //   itemDetails.ConversionFactor = Number(itemDetails.ConversionFactor);
                itemDetails.ConversionFactor = Number(selectedRow.find('[id^=txtCF_]').val());

                if (selectedRow.find('[id^=spnIsExpirable_]').text() == "1")
                    ExpiryDate = selectedRow.find('[id^=txtExp_]').val().split('/')[0] + '/01/20' + selectedRow.find('[id^=txtExp_]').val().split('/')[1];
                else
                    ExpiryDate = '01/01/0001';

                if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                    $cgstPer = 0;//
                    $sgstPer = 0;//
                    $igstPer = 0;//
                    $mrp = 0;//
                    $cgstAmt = 0;
                    $sgstAmt = 0;
                    $igstAmt = 0;
                    $totalGSTPer = 0;
                    $totalGSTAmt = 0;

                    if (selectedRow.find('[id^=txtCGST_]').val() != "")
                        $cgstPer = parseFloat(selectedRow.find('[id^=txtCGST_]').val());//
                    if (selectedRow.find('[id^=txtSGST_]').val() != "")
                        $sgstPer = parseFloat(selectedRow.find('[id^=txtSGST_]').val());//
                    if (selectedRow.find('[id^=txtIGST_]').val() != "")
                        $igstPer = parseFloat(selectedRow.find('[id^=txtIGST_]').val());//
                    if (selectedRow.find('[id^=txtMrp_]').val() != "")
                        $mrp = selectedRow.find('[id^=txtMrp_]').val();



                    var GSTID = selectedRow.find('[id^=ddlGSTType_]').val();
                    var filterGST = gstPercentage.filter(function (i) { return i.id == GSTID });

                    if (filterGST[0].TaxGroup.toUpperCase() == 'IGST') {
                        $igstPer = parseFloat(selectedRow.find('[id^=txtIGST_]').val());
                        $igstAmt = parseFloat(selectedRow.find('[id^=spnIGSTAmt_]').text());

                    } else if (filterGST[0].TaxGroup.toUpperCase() == 'CGST&SGST') {
                        $cgstPer = parseFloat(selectedRow.find('[id^=txtCGST_]').val());
                        $sgstPer = parseFloat(selectedRow.find('[id^=txtSGST_]').val());
                        $cgstAmt = parseFloat(selectedRow.find('[id^=spnCGSTAmt_]').text());
                        $sgstAmt = parseFloat(selectedRow.find('[id^=spnSGSTAmt_]').text());
                    }
                    else {
                        $cgstPer = parseFloat(selectedRow.find('[id^=txtCGST_]').val());
                        $sgstPer = parseFloat(selectedRow.find('[id^=txtSGST_]').val());
                        $cgstAmt = parseFloat(selectedRow.find('[id^=spnCGSTAmt_]').text());
                        $sgstAmt = parseFloat(selectedRow.find('[id^=spnUTGSTAmt_]').text());
                    }
                    //$isDeal = '';
                    //if (selectedRow.find('[id^=txtDeal1_]').val() != '' && selectedRow.find('[id^=txtDeal2_]').val() != '') {
                    //    $isDeal = (selectedRow.find('[id^=txtDeal1_]').val() + "+" + selectedRow.find('[id^=txtDeal2_]').val());
                    //}

                    $totalGSTPer = $igstPer + $cgstPer + $sgstPer;
                    $totalGSTAmt = $sgstAmt + $igstAmt + $cgstAmt;
                }

                if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                    var GSTID = selectedRow.find('[id^=ddlGSTType_]').val();
                    var filterGST = gstPercentage.filter(function (i) { return i.id == GSTID });

                    var data = {
                        DeptLedgerNo: $.trim('<%= ViewState["DeptLedgerNo"].ToString()%>'),
                        ItemID: selectedRow.find('[id^=spnItemId_]').text(),
                        ItemName: selectedRow.find('[id^=spnItemName_]').text(),
                        BatchNumber: $.trim(selectedRow.find('[id^=txtBatchNo_]').val()),
                        MRP: $mrp,  //selectedRow.find('[id^=txtMrp_]').val(),
                        Quantity: selectedRow.find('[id^=txtQty_]').val(),
                        Rate: Number(selectedRow.find('[id^=txtRate_]').val()),
                        DiscPer: Number(selectedRow.find('[id^=txtDiscPer_]').val()),
                        DiscAmt: Number(selectedRow.find('[id^=txtDiscAmt_]').val()),
                        PurTaxPer: Number($totalGSTPer),
                        PurTaxAmt: Number($totalGSTAmt),
                        //  MedExpiryDate: selectedRow.find('[id^=txtExp_]').val(),
                        MedExpiryDate: ExpiryDate,
                        ItemNetAmount: Number(selectedRow.find('[id^=txtNetAmount_]').val()),
                        ItemGrossAmount: Number(selectedRow.find('[id^=txtNetAmount_]').val()),
                        isDeal: selectedRow.find('[id^=txtDeal1_]').val() + '+' + selectedRow.find('[id^=txtDeal2_]').val(),
                        markUpPercent: Number(selectedRow.find('[id^=spnMarkUpPercent_]').text()),
                        PODID: Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').text()),
                        LedgerTnxNo: Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').attr('ledgerTnxNo')),
                        StockID: Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').attr('stockNo')),
                        otherCharges: Number(selectedRow.find('[id^=txtOtherCharges_]').val()),
                        SaleTaxPer: Number(selectedRow.find('[id^=spnSaleTaxPercent_]').text()),
                        IsFree: Number(selectedRow.find('[id^=spnIsFree_]').text()),
                        StoreLedgerNo: storeLedgerNo,
                        Naration: narration,
                        SubCategoryID: itemDetails.SubCategoryID,
                        MajorUnit: itemDetails.majorUnit,
                        MinorUnit: itemDetails.minorUnit,
                        ConversionFactor: itemDetails.ConversionFactor,
                        MajorMRP: 0,
                        IsExpirable: itemDetails.IsExpirable,
                        SpecialDiscPer: Number(selectedRow.find('[id^=txtSpclDiscPer_]').val()),
                        SpecialDiscAmt: Number(selectedRow.find('[id^=spnSpclDiscAmt_]').text()),

                        IsReturn: 0,
                        HSNCode: selectedRow.find('[id^=txtHSNCode_]').val(),
                        GSTType: filterGST[0].TaxGroup.toUpperCase(),
                        IGSTPercent: $igstPer,
                        CGSTPercent: $cgstPer,
                        SGSTPercent: $sgstPer,
                        IGSTAmt: $igstAmt,
                        CGSTAmt: $cgstAmt,
                        SGSTAmt: $sgstAmt,
                        RetrunFromGRN: '',
                        RetrunFromInvoiceNo: '',
                        IsUpdateCF: Number(selectedRow.find('[id^=spnIsUpdateCF_]').text()),
                        IsUpdateHSNCode: Number(selectedRow.find('[id^=spnIsUpdateHSNCode_]').text()),
                        IsUpdateGST: Number(selectedRow.find('[id^=spnIsUpdateGST_]').text()),
                        IsUpdateExpirable: Number(selectedRow.find('[id^=spnIsUpdateExpirable_]').text())
                    };
                }
                else {
                    var data = {
                        DeptLedgerNo: $.trim('<%= ViewState["DeptLedgerNo"].ToString()%>'),
                        ItemID: selectedRow.find('[id^=spnItemId_]').text(),
                        ItemName: selectedRow.find('[id^=spnItemName_]').text(),
                        BatchNumber: $.trim(selectedRow.find('[id^=txtBatchNo_]').val()),
                        MRP: selectedRow.find('[id^=txtMrp_]').val(),
                        Quantity: selectedRow.find('[id^=txtQty_]').val(),
                        Rate: Number(selectedRow.find('[id^=txtRate_]').val()),
                        DiscPer: Number(selectedRow.find('[id^=txtDiscPer_]').val()),
                        DiscAmt: Number(selectedRow.find('[id^=txtDiscAmt_]').val()),
                        PurTaxPer: Number(selectedRow.find('[id^=txtVAT_]').val()),
                        PurTaxAmt: Number(selectedRow.find('[id^=txtVATAmount_]').val()),
                        //  MedExpiryDate: selectedRow.find('[id^=txtExp_]').val(),
                        MedExpiryDate: ExpiryDate,
                        ItemNetAmount: Number(selectedRow.find('[id^=txtNetAmount_]').val()),
                        ItemGrossAmount: Number(selectedRow.find('[id^=txtNetAmount_]').val()),
                        isDeal: selectedRow.find('[id^=txtDeal1_]').val() + '+' + selectedRow.find('[id^=txtDeal2_]').val(),
                        markUpPercent: Number(selectedRow.find('[id^=spnMarkUpPercent_]').text()),
                        PODID: Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').text()),
                        LedgerTnxNo: Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').attr('ledgerTnxNo')),
                        StockID: Number(selectedRow.find('[id^=spnPurchaseOrderDetailID_]').attr('stockNo')),
                        otherCharges: Number(selectedRow.find('[id^=txtOtherCharges_]').val()),
                        SaleTaxPer: Number(selectedRow.find('[id^=spnSaleTaxPercent_]').text()),
                        IsFree: Number(selectedRow.find('[id^=spnIsFree_]').text()),
                        StoreLedgerNo: storeLedgerNo,
                        Naration: narration,
                        SubCategoryID: itemDetails.SubCategoryID,
                        MajorUnit: itemDetails.majorUnit,
                        MinorUnit: itemDetails.minorUnit,
                        ConversionFactor: itemDetails.ConversionFactor,
                        MajorMRP: 0,
                        IsExpirable: itemDetails.IsExpirable,
                        SpecialDiscPer: 0,
                        SpecialDiscAmt: 0,

                        IsReturn: 0,
                        HSNCode: '',
                        GSTType: '',
                        IGSTPercent: 0,
                        CGSTPercent: 0,
                        SGSTPercent: 0,
                        IGSTAmt: 0,
                        CGSTAmt: 0,
                        SGSTAmt: 0,
                        RetrunFromGRN: '',
                        RetrunFromInvoiceNo: '',
                        IsUpdateCF: 0,
                        IsUpdateHSNCode: 0,
                        IsUpdateGST: 0,
                        IsUpdateExpirable: 0,
                    };
                }

                data.UnitPrice = precise_round((data.ItemNetAmount / data.Quantity), 4);
                data.InvoiceNo = GRNSummary.InvoiceNo;
                data.ChalanNo = GRNSummary.ChalanNo;
                data.InvoiceDate = GRNSummary.InvoiceDate;
                data.ChalanDate = GRNSummary.ChalanDate;
                data.VenLedgerNo = GRNSummary.VenLedgerNo;
                data.InvoiceAmount = GRNSummary.NetAmount;
                data.ItemGrossAmount = precise_round((data.Rate * data.Quantity), 4)
                GRNItemDetails.push(data);
            });

            var IsConsignment = Number($('input[type=radio][name$=rbtIsConsignment]:checked').val());
            var _grnDetails = { dataInvoice: [GRNSummary], dataItemDetails: GRNItemDetails, isConsignment: IsConsignment, consignmentNumber: 0 };
            console.log(_grnDetails);
            callback(_grnDetails);
        }



        $clear = function () {
            var editConsignmentNo = Number('<%=Util.GetString(Request.QueryString["ledgerTransactionNo"])  %>');
            if (String.isNullOrEmpty(editConsignmentNo)) {
                location.reload();
            }
            else {
                window.location.href = 'DirectGRNSearch.aspx';
            }
        }

        var ShowRequiredField = function () {

            var GRNType = Number($('#ddlGRNType').val());
            if (GRNType == 0) {
                $("#txtBillNo").addClass("requiredField");
                $("#txtBillDate").addClass("requiredField");
                $("#txtChallanNo").removeClass("requiredField");
                $("#txtChallanDate").removeClass("requiredField");

            }
            if (GRNType == 1) {
                $("#txtChallanNo").addClass("requiredField");
                $("#txtChallanDate").addClass("requiredField");
                $("#txtBillNo").removeClass("requiredField");
                $("#txtBillDate").removeClass("requiredField");

            }
            if (GRNType == 3) {
                $("#txtBillNo").addClass("requiredField");
                $("#txtBillDate").addClass("requiredField");
                $("#txtChallanNo").addClass("requiredField");
                $("#txtChallanDate").addClass("requiredField");

            }
        }
        var validateGRNDetails = function (data, callback) {
            checkDuplicateInvoice(function () {
                var GRNType = Number($('#ddlGRNType').val());
                if (GRNType == 0 || GRNType == 3) {
                    if (String.isNullOrEmpty(data.dataInvoice[0].InvoiceNo)) {
                        modelAlert('Please Enter Invoice Number.', function () {

                        });
                        return false;
                    }

                    if (String.isNullOrEmpty(data.dataInvoice[0].InvoiceDate)) {
                        modelAlert('Please Enter Invoice Date.', function () {

                        });
                        return false;
                    }
                }

                if (GRNType == 1 || GRNType == 3) {
                    if (String.isNullOrEmpty(data.dataInvoice[0].ChalanNo)) {
                        modelAlert('Please Enter Challan Number.', function () {

                        });
                        return false;
                    }

                    if (String.isNullOrEmpty(data.dataInvoice[0].ChalanDate)) {
                        modelAlert('Please Enter Challan Date.', function () {

                        });
                        return false;
                    }
                }

                var blankItems = [];
                var blankConversionFactorItems = [];
                var blankRateItems = [];
                var blankQuantityItems = [];
                var blankBatchNumberItems = [];
                var blankExpireItems = [];
                var blankNarrationItems = [];
                var blankMRP = [];
                var rateMoreThanMRP = [];
                $(data.dataItemDetails).each(function (i, item) {
                    //console.log(item);
                    // console.log(item.MedExpiryDate);
                  
                    if (String.isNullOrEmpty(item.ItemID))
                        blankItems.push(item);

                    if (String.isNullOrEmpty(item.BatchNumber))
                        blankBatchNumberItems.push(item);

                    if (String.isNullOrEmpty(item.Naration))
                        blankNarrationItems.push(item);


                    if (item.ConversionFactor <= 0)
                        blankConversionFactorItems.push(item);

                    if (item.Rate <= 0)
                        blankRateItems.push(item);

                    if (item.Quantity <= 0)
                        blankQuantityItems.push(item);


                    if (item.IsExpirable == 1) {
                        if (String.isNullOrEmpty(item.MedExpiryDate) || item.MedExpiryDate == "/01/20undefined")
                            blankExpireItems.push(item);

                    }

                    if (Number(item.MRP) <= 0)
                        blankMRP.push(item);

                    //if ((item.ItemNetAmount / item.Quantity) > item.MRP) {
                    //    rateMoreThanMRP.push(item);
                    //}
                });



                if (blankItems.length > 0) {
                    modelAlert('Please Select Items.');
                    return false;
                }



                if (blankConversionFactorItems.length > 0) {
                    modelAlert('Enter Conversion Factor.');
                    return false;
                }


                if (blankRateItems.length > 0) {
                    modelAlert('Enter Rate.');
                    return false;
                }

                if (blankQuantityItems.length > 0) {
                    modelAlert('Enter Quantity.');
                    return false;
                }

                if (blankMRP.length > 0) {
                    modelAlert('Enter Selling Price.');
                    return false;
                }

                //if (rateMoreThanMRP.length > 0) {
                //    modelAlert("MRP Can't Less Then Rate.");
                //    return false;
                //}

                if (blankBatchNumberItems.length > 0) {
                    modelAlert('Enter Batch Number.');
                    return false;
                }

                if (true) {

                }

                if (blankExpireItems.length > 0) {
                    modelAlert('Enter Expiry.');
                    return false;
                }


                if (blankNarrationItems.length > 0) {
                    modelAlert('Enter Narration.');
                    return false;
                }



                if (String.isNullOrEmpty(data.dataInvoice[0].CurrencyFactor) || Number(data.dataInvoice[0].CurrencyFactor) == 0) {
                    modelAlert('Currency Factor can not be Blank or Zero');
                    $('txtCurrencyFactor').focus();
                    return false;
                }

                callback();

            });

        }



        var checkDuplicateInvoice = function (callback) {


            var ledgerTransactionNo = Number('<%= Util.GetString(Request.QueryString["ledgerTransactionNo"]) %>');

            if (ledgerTransactionNo > 0) {
                callback();
            }
            else {
                serverCall('Services/WebService.asmx/checkDuplicateInvoice', { VendorLedgerNo: $('#ddlVendor').val().split('#')[0], InvoiceNo: $('#txtBillNo').val(), ChallanNo: $('#txtChallanNo').val(), Type: $('#ddlGRNType option:selected').text() }, function (response) {
                    if (response == "1") {
                        modelAlert('Invoice No. Already Exist');
                        return false;
                    }
                    if (response == "2") {
                        modelAlert('Challan No. Already Exist');
                        return false;
                    }
                    if (response == "0") {
                        callback();
                    }
                });
            }

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

            // Delete Last Item
            shortcut.add('Alt+C', function () {

                var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());
                if (String.isNullOrEmpty(selectedPurchaseOrder))
                    removeRow($('#tb_ItemsList tbody tr:last td  #btnRemove_')[0], function () { });

            }, addShortCutOptions);

            // Add Free Item
            shortcut.add('Alt+V', function () {
                var row = $('#tb_ItemsList tbody tr:last').attr('tableid');//
                onAddFreeItem($('#tb_ItemsList tbody tr:last td  #btnAddFree_')[0], row);
            }, addShortCutOptions);

            // Add Other Batch Item
            shortcut.add('Alt+B', function () {
                var row = $('#tb_ItemsList tbody tr:last').attr('tableid');//
                onAddSameBatchItem($('#tb_ItemsList tbody tr:last td  #btnAddSameBatch_')[0], row);//
            }, addShortCutOptions);

            // Add New Item
            shortcut.add('Alt+N', function () {
                var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());
                if (String.isNullOrEmpty(selectedPurchaseOrder))
                    onAddNewRow($('#tb_ItemsList tbody tr:last td  #btnAdd_')[0]);

            }, addShortCutOptions);


            shortcut.add('Enter', function () {
                var focused = document.activeElement;
                var newRowControl = ['txtDiscAmt_', 'txtExp_'];

                if (newRowControl.indexOf(focused.id) > -1) {
                    var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
                    var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());
                    if (String.isNullOrEmpty(selectedPurchaseOrder)) {
                        addNewItemRow(0, storeLedgerNo, function (row) {
                            bindAutoComplete(row, function () { });
                            bindTaxCalculationOn(row, function () { });
                            $bindGSTTypee(row, function () { });
                        });
                    }
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
    </script>



    <script type="text/javascript" id="scriptPurchaseOrderGRN">




        var getPurchaseOrderSelect = function (el) {
            var selectRow = $(el).closest('tr');
            var purchaseOrderNumber = $(selectRow).find('#td1').text();
            bindPurchaseOrderItemDetails(purchaseOrderNumber, function () {
                $('.selectedPurchaseOrder').removeClass('hidden').find('#lblSelectedPurchaseOrder').text(purchaseOrderNumber);
            });

        }




        var getPurchaseOrderItemDetails = function (purchaseOrderNumber, callback) {
            var purchaseOrderNumber = purchaseOrderNumber;
            serverCall('DirectGRN.aspx/GetPurchaseOrderItems', { purchaseOrderNumber: purchaseOrderNumber }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }

        // var grossamt = 0, igstpercnt = 0, cgstpercnt = 0, sgstpercnt = 0, discamt = 0,taxamt = 0,$IGSTTAmt = 0, $CGSTTAmt = 0, $SGSTTAmt = 0, $UTGSTTAmt = 0;
        var bindPurchaseOrderItemDetails = function (purchaseOrderNumber, callback) {
            getPurchaseOrderItemDetails(purchaseOrderNumber, function (data) {
                $('#lblPurchaseOrderNumber').text(purchaseOrderNumber);
                if (data.length > 0) {
                    $('#tb_ItemsList tbody').find('tr').remove();
                    $(data).each(function (i, item) {
                        $("#txtBillGrossAmt").val("0.00");
                        $("#txtRoundOff").val("0.00");
                        $("#txtTotalIGST").val("0.00");
                        $("#txtTotalCGST").val("0.00");
                        $("#txtTotalUTGST").val("0.00");
                        $("#txtTotalSGST").val("0.00");
                        $("#txtInvoiceAmount").val("0.00");
                        $("#txtTotalDiscount").val("0.00");
                        addNewItemRow(item.isfree, this.StoreLedgerNo, function (selectedRow) {
                            (selectedRow, function () { });
                            bindTaxCalculationOn(selectedRow, function () { });
                            selectedRow.find('[id^=txtItemName_]').val(item.ItemName).prop('disabled', true);
                            selectedRow.find('[id^=txtCF_]').val(precise_round(item.ConversionFactor, 1));
                            selectedRow.find('[id^=ddlTaxCalOn_]').val(item.TaxCalulatedOn);

                            selectedRow.find('[id^=txtDeal1_]').val(item.IsDeal);
                            selectedRow.find('[id^=txtDeal2_]').val(item.IsDeal);
                            selectedRow.find('[id^=txtRate_]').val(item.RateDisplay);
                            selectedRow.find('[id^=txtQty_]').val(item.RemainQty);
                            selectedRow.find('[id^=txtMrp_]').val(item.MRP);
                            selectedRow.find('[id^=txtBatchNo_]').val('');
                            selectedRow.find('[id^=txtDiscPer_]').val(item.Discount_p);
                            selectedRow.find('[id^=txtDiscAmt_]').val(0);
                            calculateDiscountAmount(selectedRow, precise_round((item.RateDisplay * item.OrderedQty), 4), item.Discount_p);



                            selectedRow.find('[id^=txtVAT_]').val(item.VATPer);
                            selectedRow.find('[id^=txtVATAmount_]').val(item.VATAmt);
                            selectedRow.find('[id^=txtOtherCharges_]').val(0);
                            selectedRow.find('[id^=txtNetAmount_]').val(item.ActualAmount);

                            selectedRow.find('[id^=spnPurchaseSalesUnit_]').text(item.MajorUnit + '/' + item.MinorUnit);
                            selectedRow.find('[id^=spnItemName_]').text(item.ItemName);
                            selectedRow.find('[id^=spnItemId_]').text(item.ItemID);
                            selectedRow.find('[id^=spnIsExpirable_]').text(item.IsExpirable);
                            selectedRow.find('[id^=spnSubCategoryID_]').text(item.SubCategoryID);
                            selectedRow.find('[id^=spnNetAmount_]').text(item.ActualAmount);
                            //selectedRow.find('[id^=spnDiscPer_]').text(item.ItemName);
                            //selectedRow.find('[id^=spnDiscAmt_]').text(item.ItemName);
                            //selectedRow.find('[id^=spnGrossAmt_]').text(item.ItemName);
                            //selectedRow.find('[id^=spnUnitPrice_]').text(item.ItemName);
                            selectedRow.find('[id^=spnIsFree_]').text(item.isfree);
                            selectedRow.find('[id^=spnMarkUpPercent_]').text(0);
                            selectedRow.find('[id^=spnOtherCharges_]').text(0);
                            selectedRow.find('[id^=spnPurUnit_]').text(item.MajorUnit);
                            selectedRow.find('[id^=spnSalesUnit_]').text(item.MinorUnit);
                            selectedRow.find('[id^=spnPurchaseOrderDetailID_]').text(item.PurchaseOrderDetailID);
                            selectedRow.find('[id^=spnSaleTaxPercent_]').text(item.DefaultSaleVatPercentage);
                            if (item.IsExpirable == 0)
                                selectedRow.find('[id^=txtExp_]').prop('disabled', true);
                            else
                                selectedRow.find('[id^=txtExp_]').prop('disabled', false).addClass('required');

                            if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                                //  grossamt += (item.RateDisplay * item.RemainQty);
                                //igstpercnt += (item.IGSTPercent);
                                //cgstpercnt += (item.CGSTPercent);
                                //sgstpercnt += (item.SGSTPercent);
                                // discamt += (precise_round((item.RateDisplay * item.OrderedQty), 4) * item.Discount_p) / 100;




                                selectedRow.find('[id^=txtHSNCode_]').val(item.HSNCode);
                                selectedRow.find('[id^=spnDiscAmt_]').text((precise_round((item.RateDisplay * item.OrderedQty), 4) * item.Discount_p) / 100);
                                selectedRow.find('[id^=spnDiscPer_]').text(item.Discount_p);

                                selectedRow.find('[id^=spnGrossAmt_]').text(item.RateDisplay * item.OrderedQty);
                                $bindGSTTypee(selectedRow, function () {


                                    selectedRow.find("[id^=ddlGSTType_] option:contains('" + item.GSTTypeNew + "')").attr('selected', true);

                                    if (item.GSTType == "IGST") {
                                        // selectedRow.find('[id^=ddlGSTType_]').val("T4");
                                        //selectedRow.find('[id^=txtIGST_]').attr('disabled', false);
                                        //selectedRow.find('[id^=txtCGST_]').attr('disabled', true);
                                        //selectedRow.find('[id^=txtSGST_]').attr('disabled', true);

                                        selectedRow.find('[id^=txtIGST_]').val(item.IGSTPercent);


                                        // $IGSTTAmt += precise_round((item.IGSTAmt), 4);
                                        selectedRow.find('[id^=spnIGSTAmt_]').text(precise_round(item.IGSTAmt, 4));
                                    }
                                    else if (item.GSTType == "CGST&UTGST") {//
                                        // selectedRow.find('[id^=ddlGSTType_]').val("T7");
                                        //selectedRow.find('[id^=txtIGST_]').attr('disabled', true);
                                        //selectedRow.find('[id^=txtCGST_]').attr('disabled', false);
                                        //selectedRow.find('[id^=txtSGST_]').attr('disabled', false);

                                        selectedRow.find('[id^=txtCGST_]').val(item.CGSTPercent);
                                        selectedRow.find('[id^=txtSGST_]').val(item.SGSTPercent);

                                        //  $CGSTTAmt += precise_round((item.CGSTAmt), 4);
                                        // $UTGSTTAmt += precise_round((item.SGSTAmt), 4);
                                        selectedRow.find('[id^=spnCGSTAmt_]').text(precise_round((item.CGSTAmt), 4));
                                        selectedRow.find('[id^=spnUTGSTAmt_]').text(precise_round((item.SGSTAmt), 4));
                                        // selectedRow.find('[id^=spnSGSTAmt_]').text(item.SGSTPercent);
                                    }
                                    else {//
                                        // selectedRow.find('[id^=ddlGSTType_]').val("T6");
                                        //selectedRow.find('[id^=txtIGST_]').attr('disabled', true);
                                        //selectedRow.find('[id^=txtCGST_]').attr('disabled', false);
                                        //selectedRow.find('[id^=txtSGST_]').attr('disabled', false);

                                        selectedRow.find('[id^=txtCGST_]').val(item.CGSTPercent);
                                        selectedRow.find('[id^=txtSGST_]').val(item.SGSTPercent);

                                        // $CGSTTAmt += precise_round((item.CGSTAmt), 4);
                                        //  $SGSTTAmt += precise_round((item.SGSTAmt), 4);
                                        selectedRow.find('[id^=spnCGSTAmt_]').text(precise_round((item.CGSTAmt), 4));
                                        selectedRow.find('[id^=spnSGSTAmt_]').text(precise_round((item.SGSTAmt), 4));
                                        // selectedRow.find('[id^=spnSGSTAmt_]').text(item.SGSTPercent);
                                    }
                                });
                            }

                            var _temp = {
                                label: item.ItemName,
                                val: item.ItemName,
                                ItemID: item.ItemID,
                                IsExpirable: item.IsExpirable,
                                minorUnit: item.MinorUnit,
                                ConversionFactor: item.ConversionFactor,
                                majorUnit: item.MajorUnit,
                                HSNCode: '',
                                SubCategoryID: item.SubCategoryID,
                                VatType: item.VatType,
                                value: item.ItemName,
                                Minimum_Tolerance_Qty: item.Minimum_Tolerance_Qty,
                                Maximum_Tolerance_Qty: item.Maximum_Tolerance_Qty,
                                Minimum_Tolerance_Rate: item.Minimum_Tolerance_Rate,
                                Maximum_Tolerance_Rate: item.Maximum_Tolerance_Rate,
                                InitialCount: item.OrderedQty,
                                RemainQty: item.RemainQty,
                                RateDisplay: item.RateDisplay
                            }

                            selectedRow.find('.tdData').text(JSON.stringify(_temp));

                            // selectedRow.find('.itemAddRemove').hide();

                            if (item.isfree == 1)
                                setIsFreeDefaultValue(selectedRow, function () { });

                            var maxToleranceQuantity = precise_round(Number(item.RemainQty + (item.OrderedQty * item.Maximum_Tolerance_Qty / 100)), 4);

                            selectedRow.find('[id^=txtQty_]').attr('title', 'Approved Quantity :- ' + item.OrderedQty + '\nReceived Quantity :- ' + item.RecievedQty + '\nRemain Quantity :- ' + item.RemainQty + '\nMax Tolerance Quantity :- ' + maxToleranceQuantity);

                            var rate = Number(item.tdRate);
                            var maxToleranceRate = precise_round(Number(item.RateDisplay + (item.RateDisplay * item.Maximum_Tolerance_Rate / 100)), 4);
                            var minToleranceRate = precise_round(Number(item.RateDisplay - (item.RateDisplay * item.Minimum_Tolerance_Rate / 100)), 4);

                            selectedRow.find('[id^=txtRate_]').attr('title', 'Max Tolerance Rate :- ' + maxToleranceRate + '\nMin Tolerance Rate :- ' + minToleranceRate);

                            selectedRow.find('#btnAdd_').addClass('hidden');

                            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                                onQuantityChange(selectedRow.find('[id^=txtQty_]'), function () { });
                            }


                        });
                    });

                    var selecctedVendorValue = data[0].VendorID;
                    $('#ddlVendor option').each(function () {
                        if (this.value.split('#')[0] == data[0].VendorID) {
                            selecctedVendorValue = this.value;
                        }
                    });


                    $('#txtOtherCharges').val(data[0].OtherCharges).change();
                    disableBillInvoiceDetails(false);
                    $('#ddlVendor').prop('disabled', true).val(selecctedVendorValue).trigger("chosen:updated");
                    $('#rblStoreType').find('input[type=radio][value=' + data[0].StoreLedgerNo + ']').prop('checked', true)
                    $('#rblStoreType').find('input[type=radio]').prop('disabled', true);

                    $('#ddlCurrency').prop('disabled', true).val(data[0].S_CountryID);
                    $('#txtCurrencyFactor').prop('disabled', true).val(Number(data[0].C_Factor));
                    $('#rdoGRNPayType input[type=radio][value=' + data[0].PaymentModeID + ']').prop('checked', true);
                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                        $UpdateAmounts(function () { });
                        // $("#txtBillGrossAmt").val(grossamt);
                        //$("#txtTotalIGST").val(igstpercnt);
                        //$("#txtTotalCGST").val(cgstpercnt);
                        //$("#txtTotalSGST").val(sgstpercnt);
                        // $("#txtTotalDiscount").val(discamt);
                    }
                    $('#divPurchaseOrders').hideModel();
                    callback();
                }
                else {
                    modelAlert('Item Not Found.');
                }
            });
        }





        var getPurchaseOrders = function (el, e) {

            var storeLedgerNo = $('input[type=radio][name$=rblStoreType]:checked').val();
            var purchaseOrderFromDate = $.trim($('#txtPurchaseOrderFromDate').val());
            var purchaseOrderToDate = $.trim($('#txtPurchaseOrderToDate').val());

            var purchaseOrderNumber = $.trim($('#txtPurchaseOrderSearch').val());
            var vendorID = $.trim($('#ddlVendorSearch').val().split('#')[0]);
            vendorID = (vendorID == '0' ? '' : vendorID);

            if (el.id == 'txtPurchaseOrderSearch') {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code != 13)
                    return false
            }



            serverCall('DirectGRN.aspx/GetPurchaseOrders',
                {
                    StoreType: storeLedgerNo,
                    purchaseOrderFromDate: purchaseOrderFromDate,
                    purchaseOrderToDate: purchaseOrderToDate,
                    purchaseOrderNumber: purchaseOrderNumber,
                    vendorID: vendorID
                }, function (response) {
                    responseData = JSON.parse(response);
                    var parseHTML = $('#templatePurchaseOrders').parseTemplate(responseData);
                    $('#divPurchaseOrders').find('.modal-body .purchaseOrderDetails').html(parseHTML);
                    $('#divPurchaseOrders').showModel();
                    $('#ddlVendorSearch').chosen();
                });
        }

        var onPurchaseOrderSearchDateChange = function (el, event) {
            getPurchaseOrders(el, event);
        }


    </script>

      <script id="templatePurchaseOrders" type="text/html">   
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="tblPurchaseOrder" style="width:100%;border-collapse:collapse;">                                  
        <tr id="MedHeader">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Supplier</th>
            <th class="GridViewHeaderStyle" scope="col" >Purchase Order</th>
            <th class="GridViewHeaderStyle" scope="col" >Rasied By</th>
            <th class="GridViewHeaderStyle" scope="col" >Rasied On</th>
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
       </tr>
       <#       
              var dataLength=responseData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var k=0;k<dataLength;k++)
        {
        objRow = responseData[k];      
            #>        
                  <tr onmouseover="this.style.backgroundColor='#00ff00'"'  onMouseOut="this.style.backgroundColor=''" style='cursor:pointer;'>                            
                    <td class="GridViewLabItemStyle" > <#=k+1#></td> 
                    <td class="GridViewLabItemStyle" id="tdVendorName" ><#=objRow.VendorName#></td>
                    <td class="GridViewLabItemStyle" id="td1" style="text-align:center"><#=objRow.PurchaseOrderNo#></td>
                    <td class="GridViewLabItemStyle" id="td3" style="text-align:center"><#=objRow.EmployeeName#></td>   
                    <td class="GridViewLabItemStyle" id="tdrate" style="text-align:center"><#=objRow.RaisedOn#></td>    
                    <td class="GridViewLabItemStyle" id="td2" style="text-align:center">
                        <img src="../../Images/Post.gif" alt="" style="cursor:pointer" onclick="getPurchaseOrderSelect(this);" /> 

                    </td>                 
                 </tr>
            <#}#>                      
     </table>     
    </script>


      <div id="divGRNList" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: auto; height: 300px">
                    <div class="modal-header">
                        <button type="button" class="close" aria-hidden="true" onclick="closeGRNList()">&times;</button>
                        <h4 class="modal-title">Last 10 GRN</h4>
                    </div>
                    <div class="modal-body" style="margin: 15px; overflow: auto;">
                        <table id="tb_GRNList" style="width: 100%; border-collapse: collapse;">
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>


    <div id="divPurchaseOrders" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 860px;height: 500px;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="divPurchaseOrders" aria-hidden="true">×</button>
				<h4 class="modal-title">Purchase Orders</h4>
			</div>
			<div class="modal-body">
			   <div class="row">
                   <div class="col-md-4">
                        <label class="pull-left">
                                   From Date
                                </label>
                        <b class="pull-right">:</b>
                   </div>
                   <div class="col-md-8">
                       <asp:TextBox runat="server" ID="txtPurchaseOrderFromDate" ClientIDMode="Static" onchange="onPurchaseOrderSearchDateChange(this,event)" ></asp:TextBox>
                       <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtPurchaseOrderFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
                   </div>
                   <div class="col-md-4">
                        <label class="pull-left">
                                   To Date
                                </label>
                        <b class="pull-right">:</b>
                   </div>
                   <div class="col-md-8">
                       <asp:TextBox runat="server" ID="txtPurchaseOrderToDate" ClientIDMode="Static" onchange="onPurchaseOrderSearchDateChange(this,event)"></asp:TextBox>
                       <cc1:CalendarExtender ID="calExdTxtSearchModelToDate" TargetControlID="txtPurchaseOrderToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
                   </div>
			   </div>

                  <div class="row">
                   <div class="col-md-4">
                        <label class="pull-left">
                                   PurchaseOrder
                                </label>
                        <b class="pull-right">:</b>
                   </div>
                   <div class="col-md-8">
                          <input type="text" id="txtPurchaseOrderSearch" onkeyup="onPurchaseOrderSearchDateChange(this,event)" />
                    </div>

                      <div class="col-md-4">
                        <label class="pull-left">
                                   Supplier
                                </label>
                        <b class="pull-right">:</b>
                   </div>
                   <div class="col-md-8">
                          <%--<select id="ddlDepartmentSearch"></select>--%>
                       <asp:DropDownList runat="server" ID="ddlVendorSearch" ClientIDMode="Static" onchange="onPurchaseOrderSearchDateChange(this,event)" ></asp:DropDownList>
                    </div>
                   </div>


			   <div class="row purchaseOrderDetails" style="height:330px;overflow:auto">

			   </div>
	       </div>
			<div class="modal-footer">
				 <button type="button" data-dismiss="divPurchaseOrders">Close</button>
			</div>
		</div>
	</div>
</div>




    


    
    <script type="text/javascript">



        function closeGRNList() {
        
            $('#tb_GRNList tbody').empty();
            $('#divGRNList').hide();

        }


        var getGRNItemDetails = function (ledgertransactionNo, callback) {
            //$('#tb_ItemsList tbody').find('tr').remove();
            var data = {
                ledgertransactionNo: ledgertransactionNo,
                centreID: '<%= HttpContext.Current.Session["centreID"].ToString() %>'
            }
            serverCall('DirectGRN.aspx/GetGRNEditDetails', data, function (response) {

                var responseData = JSON.parse(response);
                callback(responseData);

            });
        }



        var onGRNEdit = function (consignmentNo) {
            bindGRNItemDetails(consignmentNo, function () {

            });
        }




        var grosamunt = 0, igstpercent = 0, cgstpercent = 0, sgstpercent = 0, discameunt = 0, taxamunt = 0;
        var bindGRNItemDetails = function (ledgertransactionNo, callback) {
            getGRNItemDetails(ledgertransactionNo, function (data) {
                $('#tb_ItemsList tbody tr').remove();
                $('#lblLedgerTransactionNo').text(ledgertransactionNo);
                $('#lblGRNNoPre').text('<%= Util.GetString(Request.QueryString["billNo"]) %>');
                $('.GRNEdit').removeClass('hidden');
                $('#divPageName b').text('Update GRN');
                $('#rblStoreType input[type=radio],#btnShowPO').prop('disabled', true);
                if (data.length > 0) {
                    debugger;
                    $(data).each(function (i, item) {
                        console.log(item);
                        addNewItemRow(item.IsFree, this.DeptLedgerNo, function (selectedRow) {
                            bindAutoComplete(selectedRow, function () { });
                            bindTaxCalculationOn(selectedRow, function () { });

                            bindTaxCalculationOn(selectedRow, function () { });
                            selectedRow.find('[id^=txtItemName_]').val(item.ItemName);
                            selectedRow.find('[id^=txtCF_]').val(precise_round(item.ConversionFactor, 1));
                            //Np selectedRow.find('[id^=ddlTaxCalOn_]').val(item.TaxCalulatedOn);

                            selectedRow.find('[id^=txtDeal1_]').val('');
                            selectedRow.find('[id^=txtDeal2_]').val('');
                            selectedRow.find('[id^=txtRate_]').val(item.Rate);

                            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                                selectedRow.find('[id^=txtMrp_]').val(item.UnitPrice);
                                selectedRow.find('[id^=txtQty_]').val(item.InitialCount);
                                selectedRow.find('[id^=txtDiscAmt_]').val(item.DiscAmt);
                            }
                            else if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                                selectedRow.find('[id^=txtMrp_]').val(item.MRP);
                                selectedRow.find('[id^=txtQty_]').val(item.Qty);
                                selectedRow.find('[id^=txtDeal1_]').val(item.D1);
                                selectedRow.find('[id^=txtDeal2_]').val(item.D2);
                            }
                            selectedRow.find('[id^=txtBatchNo_]').val(item.BatchNumber);
                            selectedRow.find('[id^=txtDiscPer_]').val(item.DiscPer);


                            calculateDiscountAmount(selectedRow, precise_round((item.Rate * item.InitialCount), 4), item.DiscPer);


                            selectedRow.find('[id^=txtVAT_]').val(item.PurTaxPer);
                            selectedRow.find('[id^=txtVATAmount_]').val(item.PurTaxAmt);
                            selectedRow.find('[id^=txtOtherCharges_]').val(0);
                            //NP selectedRow.find('[id^=txtNetAmount_]').val(item.ActualAmount);

                            //NP selectedRow.find('[id^=spnPurchaseSalesUnit_]').text(item.MajorUnit + '/' + item.MinorUnit);
                            selectedRow.find('[id^=spnItemName_]').text(item.ItemName);
                            selectedRow.find('[id^=spnItemId_]').text(item.ItemID);
                            selectedRow.find('[id^=spnIsExpirable_]').text(item.IsExpirable);
                            selectedRow.find('[id^=txtExp_]').text(item.IsExpirable);
                            selectedRow.find('[id^=spnSubCategoryID_]').text(item.SubCategoryID);
                            //NP selectedRow.find('[id^=spnNetAmount_]').text(item.ActualAmount);

                            selectedRow.find('[id^=spnIsFree_]').text(item.IsFree);
                            selectedRow.find('[id^=spnMarkUpPercent_]').text(item.MarkUpPercent);
                            selectedRow.find('[id^=spnOtherCharges_]').text(0);
                            selectedRow.find('[id^=spnPurUnit_]').text(item.MajorUnit);
                            selectedRow.find('[id^=spnSalesUnit_]').text(item.MinorUnit);
                            selectedRow.find('[id^=spnPurchaseOrderDetailID_]').text(0).attr('ledgerTnxNo', item.LedgerTnxNo).attr('stockNo', item.ID);
                            selectedRow.find('[id^=spnSaleTaxPercent_]').text(item.SaleTaxPer);
                            if (item.IsExpirable == 0)
                                selectedRow.find('[id^=txtExp_]').prop('disabled', true);
                            else
                                selectedRow.find('[id^=txtExp_]').val(item.MedExpiryDate).prop('disabled', false).addClass('required');

                            if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                                grosamunt += (item.Rate * item.Qty);
                                igstpercent += (item.IGSTPercent);
                                cgstpercent += (item.CGSTPercent);
                                sgstpercent += (item.SGSTPercent);
                                discameunt += (precise_round((item.Rate * item.Qty), 4) * item.DiscPer) / 100;

                                selectedRow.find('[id^=spnPurchaseSalesUnit_]').text(item.MajorUnit + '/' + item.MinorUnit);
                                selectedRow.find('[id^=txtHSNCode_]').val(item.HSNCode);
                                selectedRow.find('[id^=spnDiscAmt_]').text((precise_round((item.Rate * item.Qty), 0) * item.DiscPer) / 100);
                                selectedRow.find('[id^=spnDiscPer_]').text(item.DiscPer);

                                if (item.IsFree == 0) {
                                    selectedRow.find('[id^=txtNetAmount_]').val(item.NetAmount);
                                    selectedRow.find('[id^=spnNetAmount_]').text(item.NetAmount);
                                    selectedRow.find('[id^=txtDiscAmt_]').attr("disabled", false);
                                    selectedRow.find('[id^=txtDiscPer_]').attr("disabled", false);
                                    selectedRow.find('[id^=txtSpclDiscPer_]').attr("disabled", false);
                                }
                                else {
                                    selectedRow.find('[id^=txtNetAmount_]').val(0);
                                    selectedRow.find('[id^=spnNetAmount_]').text(0);
                                    selectedRow.find('[id^=txtDiscAmt_]').attr("disabled", true);
                                    selectedRow.find('[id^=txtDiscPer_]').attr("disabled", true);
                                    selectedRow.find('[id^=txtSpclDiscPer_]').attr("disabled", true);
                                }

                                selectedRow.find('[id^=txtDiscAmt_]').val((precise_round((item.Rate * item.Qty), 0) * item.DiscPer) / 100);

                                if (item.IsFree == 0) {
                                    selectedRow.find('[id^=spnGrossAmt_]').text(item.Rate * item.Qty);
                                }
                                else { selectedRow.find('[id^=spnGrossAmt_]').text(0); }


                                $bindGSTTypee(selectedRow, function () {

                                    selectedRow.find("[id^=ddlGSTType_] option:contains('" + item.GSTTypeNew + "')").attr('selected', true);

                                    if (item.GSTType == "IGST") {
                                        //  selectedRow.find('[id^=ddlGSTType_]').val("T4");
                                        //selectedRow.find('[id^=txtIGST_]').attr('disabled', false);
                                        //selectedRow.find('[id^=txtCGST_]').attr('disabled', true);
                                        //selectedRow.find('[id^=txtSGST_]').attr('disabled', true);

                                        selectedRow.find('[id^=txtIGST_]').val(item.IGSTPercent);

                                        if (item.IsFree == 0) {
                                            selectedRow.find('[id^=spnIGSTAmt_]').text(precise_round(item.VATAmt, 4));
                                        }
                                        else {
                                            selectedRow.find('[id^=spnIGSTAmt_]').text(precise_round(0, 4));
                                        }
                                    }
                                    else if (item.GSTType == "CGST&UTGST") {//
                                        //selectedRow.find('[id^=ddlGSTType_]').val("T7");
                                        //selectedRow.find('[id^=txtIGST_]').attr('disabled', true);
                                        //selectedRow.find('[id^=txtCGST_]').attr('disabled', false);
                                        //selectedRow.find('[id^=txtSGST_]').attr('disabled', false);

                                        selectedRow.find('[id^=txtCGST_]').val(item.CGSTPercent);
                                        selectedRow.find('[id^=txtSGST_]').val(item.SGSTPercent);

                                        // taxamt = precise_round((item.VATAmt / 2), 4);
                                        if (item.IsFree == 0) {
                                            selectedRow.find('[id^=spnCGSTAmt_]').text(precise_round((item.CGSTAmt), 4));
                                            selectedRow.find('[id^=spnUTGSTAmt_]').text(precise_round((item.SGSTAmt), 4));
                                        }
                                        else {
                                            selectedRow.find('[id^=spnCGSTAmt_]').text(precise_round((0), 4));
                                            selectedRow.find('[id^=spnUTGSTAmt_]').text(precise_round((0), 4));
                                        }
                                        // selectedRow.find('[id^=spnSGSTAmt_]').text(item.SGSTPercent);
                                    }
                                    else {//
                                        // selectedRow.find('[id^=ddlGSTType_]').val("T6");
                                        //selectedRow.find('[id^=txtIGST_]').attr('disabled', true);
                                        //selectedRow.find('[id^=txtCGST_]').attr('disabled', false);
                                        //selectedRow.find('[id^=txtSGST_]').attr('disabled', false);

                                        selectedRow.find('[id^=txtCGST_]').val(item.CGSTPercent);
                                        selectedRow.find('[id^=txtSGST_]').val(item.SGSTPercent);

                                        // taxamt = precise_round((item.VATAmt / 2), 4);
                                        if (item.IsFree == 0) {
                                            selectedRow.find('[id^=spnCGSTAmt_]').text(precise_round((item.CGSTAmt), 4));
                                            selectedRow.find('[id^=spnSGSTAmt_]').text(precise_round((item.SGSTAmt), 4));
                                        }
                                        else {
                                            selectedRow.find('[id^=spnCGSTAmt_]').text(precise_round((0), 4));
                                            selectedRow.find('[id^=spnSGSTAmt_]').text(precise_round((0), 4));
                                        }
                                        // selectedRow.find('[id^=spnSGSTAmt_]').text(item.SGSTPercent);
                                    }
                                });
                            }

                            var _temp = {
                                label: item.ItemName,
                                val: item.ItemName,
                                ItemID: item.ItemID,
                                IsExpirable: item.IsExpirable,
                                minorUnit: item.MinorUnit,
                                ConversionFactor: item.ConversionFactor,
                                majorUnit: item.MajorUnit,
                                HSNCode: '',
                                SubCategoryID: item.SubCategoryID,
                                VatType: item.VatType,
                                value: item.ItemName,
                                Minimum_Tolerance_Qty: 0,
                                Maximum_Tolerance_Qty: 0,
                                Minimum_Tolerance_Rate: 0,
                                Maximum_Tolerance_Rate: 0,
                                InitialCount: item.InitialCount
                            }

                            selectedRow.find('.tdData').text(JSON.stringify(_temp));

                            // selectedRow.find('.itemAddRemove').hide();
                            selectedRow.find('#btnAdd_').addClass('hidden');

                            if (item.isfree == 1)
                                setIsFreeDefaultValue(selectedRow, function () { });

                            //onQuantityChange(selectedRow.find('[id^=txtQty_]'), function () { });
                            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                                onQuantityChange(selectedRow.find('[id^=txtQty_]'), function () { });
                            }
                        });
                    });

                    var selecctedVendorValue = data[0].VenLedgerNo;
                    $('#ddlVendor option').each(function () {
                        if (this.value.split('#')[0] == data[0].VenLedgerNo) {
                            selecctedVendorValue = this.value;
                        }
                    });


                    $('#txtOtherCharges').val(data[0].OtherCharges).change();
                    disableBillInvoiceDetails(false);
                    $('#ddlVendor').prop('disabled', true).val(selecctedVendorValue).trigger("chosen:updated");
                    //$('#rblStoreType').find('input[type=radio][value=' + data[0].StoreLedgerNo + ']').prop('checked', true)
                    //$('#rblStoreType').find('input[type=radio]').prop('disabled', true);

                    $('#ddlCurrency').prop('disabled', true).val(data[0].CurrencyCountryID);
                    $('#txtCurrencyFactor').prop('disabled', true).val(Number(data[0].CurrencyFactor));
                    $('#txtNarration').val(data[0].Naration);

                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                        $UpdateAmounts(function () { });
                        //$("#txtBillGrossAmt").val(grosamunt);
                        //$("#txtTotalIGST").val(igstpercnt);
                        //$("#txtTotalCGST").val(cgstpercnt);
                        //$("#txtTotalSGST").val(sgstpercnt);
                        //$("#txtTotalDiscount").val(discameunt);
                    }

                    var grnType = 0;
                    if (!String.isNullOrEmpty(data[0].InvoiceNo))
                        grnType = 0;

                    if (!String.isNullOrEmpty(data[0].ChallanNo))
                        grnType = 1;

                    if (!String.isNullOrEmpty(data[0].ChallanNo) && !String.isNullOrEmpty(data[0].InvoiceNo))
                        grnType = 2;


                    $('#ddlGRNType').val(grnType).change();
                    $('#txtBillNo').val(data[0].InvoiceNo);
                    $('#txtBillDate').val(data[0].InvoiceDate);
                    $('#txtChallanNo').val(data[0].ChalanNo);
                    $('#txtChallanDate').val(data[0].ChallanDate);
                }
                else {
                    modelAlert('Item Not Found.');
                }
            });
        }





        var _onGRNAmountChange = function (el) {
            _disableSaveChanges(function () { });

        }



        var _disableSaveChanges = function (callback) {
            $('#btnSaveGRN').prop('disabled', true);
            callback();
        }

        var _enableSaveChanges = function (callback) {
            // validateToleranceCheck(function () {
            $('#btnSaveGRN').prop('disabled', false);
            callback();
            // });

        }

        var validateToleranceCheck = function (callback) {
            var selectedPurchaseOrder = $.trim($('#lblSelectedPurchaseOrder').text());
            if (String.isNullOrEmpty(selectedPurchaseOrder))
                callback();
            else {
                var dataTovalidate = [];
                $('#tb_ItemsList tbody tr').each(function () {
                    var tdData = JSON.parse($(this).find('.tdData').text());
                    var tdQuantity = Number($(this).find('#txtQty_').val());
                    var tdRate = Number($(this).find('#txtRate_').val());
                    tdData.tdQuantity = tdQuantity;
                    tdData.tdRate = tdRate;
                    dataTovalidate.push(tdData);
                });


                var isValid = true;
                for (var i = 0; i < dataTovalidate.length; i++) {

                    var _item = dataTovalidate[i].ItemID;
                    var tdData = dataTovalidate[i];
                    var totalQuantity = 0;

                    var items = dataTovalidate.filter(function (j) {
                        return j.ItemID == _item;
                    }).forEach(function (t) {
                        totalQuantity += Number(t.tdQuantity);
                    });


                    var maxToleranceQuantity = precise_round(Number(tdData.RemainQty + (tdData.InitialCount * tdData.Maximum_Tolerance_Qty / 100)), 4);
                    if (totalQuantity > maxToleranceQuantity) {
                        isValid = false;
                        modelAlert('<span>' + tdData.label + ' :-</span><br/><span class="patientInfo">Max Tolerance Quantity Is: ' + maxToleranceQuantity + '</span>', function () {

                        });
                        break;
                    }


                    var rate = Number(tdData.tdRate);
                    var maxToleranceRate = precise_round(Number(tdData.RateDisplay + (tdData.RateDisplay * tdData.Maximum_Tolerance_Rate / 100)), 4);
                    var minToleranceRate = precise_round(Number(tdData.RateDisplay - (tdData.RateDisplay * tdData.Minimum_Tolerance_Rate / 100)), 4);
                    if (rate > maxToleranceRate) {
                        isValid = false;
                        modelAlert('<span>' + tdData.label + ' :-</span><br/><span class="patientInfo">Max Tolerance Rate Is: ' + maxToleranceRate + '</span>', function () {

                        });
                        break;
                    }
                    else if (rate < minToleranceRate) {
                        isValid = false;
                        modelAlert('<span>' + tdData.label + ' :-</span><br/><span class="patientInfo">Min Tolerance Rate Is: ' + minToleranceRate + '</span>', function () {

                        });
                        break;
                    }



                    console.log(totalQuantity);
                }
                if (isValid)
                    callback();
            }

        };


        function ChekDuplicateBatchNo(ctr)
        {
            var Batchcount = 0;
            $(".batchNo").each(function ()
            {
                var CurrentNo = $(ctr).val();

                var row = $(this).closest('tr');
                var tddata = eval('[' + row.find(".tdData").html() + ']');
                var Ctdata = eval('[' + $(ctr).closest('tr').find(".tdData").html() + ']');
                var itemID = tddata[0]["ItemID"];// loop 
                var CitemID = Ctdata[0]["ItemID"];// Current
                if (itemID == CitemID && CurrentNo == row.find("#txtBatchNo_").val())
                {
                    Batchcount++;
                }
                if (Batchcount==2)
                {
                    $(ctr).val('');
                    Batchcount = 999;
                }
                
            });
            if (Batchcount == 999)
            { 
                modelAlert('Duplicate Batch No. not allowed for same item.', function () {
                });
                return false;
            }
            
        }
        function GetValue() {
            $UpdateAmounts(function () { });
            freightcharges = $('#txtFreight').val() == '' ? 0 : Number($('#txtFreight').val());
            var b = parseInt($('#txtInvoiceAmount').val()) + parseInt(freightcharges);
            $('#txtInvoiceAmount').val(b);
        }

    </script>






</asp:Content>
