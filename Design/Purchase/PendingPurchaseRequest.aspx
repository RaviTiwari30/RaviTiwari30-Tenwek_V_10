<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PendingPurchaseRequest.aspx.cs" Inherits="Design_Purchase_PendingPurchaseRequest" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
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

                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        function validate() {
            if ($("#ddlPRNo").val() == "0") {
                $("#lblMsg").text('Please Select PR No.');
                $("#ddlPRNo").focus();
                return false;
            }
            $("#lblMsg").text('');
        }


        $(function () {
            $('#FromDate').change(function () {
                ChkDate();
            });
            $('#ToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FromDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');

                        $('#btnSearch').attr('disabled', 'disabled');
                        $('#<%=grdPPR.ClientID %>').hide();


                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeProp('disabled');
                        $('#<%=grdPPR.ClientID %>').show();

                    }
                }
            });

        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Purchase Order by Pruchase Request </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" meta:resourcekey="lblMsgResource1" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Items
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                                <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                PR No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownCheckBoxes ID="ddlPRNo" style="border-radius: 4px; height: 22px;" runat="server" AddJQueryReference="False" CssClass="DropDownCheckBoxs"
                                UseSelectAllNode="True">
                                <Style SelectBoxWidth="195" DropDownBoxBoxWidth="160" DropDownBoxBoxHeight="90" />
                            </asp:DropDownCheckBoxes>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" ClientIDMode="Static" runat="server" OnClientClick="return validate()" CssClass="ItDoseButton" Text="Search " OnClick="btnSearch_Click" />
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="FromDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDateCal" TargetControlID="ToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Pending Purchase Request
            </div>
            <div>
                <div class="">
                    <asp:Panel ID="Panel1" runat="server" ScrollBars="vertical" Height="270px" Width="100%">
                        <asp:GridView ID="grdPPR" AutoGenerateColumns="false" runat="server" CssClass="GridViewStyle" Width="100%" OnRowDataBound="grdPPR_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="15px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PR No." HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPRNo" runat="server" Text='<%# Eval("PurchaseRequisitionNo")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="240px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("ItemName")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PR Qty." HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("ReqQty")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Supplier" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("VendorName")%>
                                        <asp:Label ID="lblVendorID" runat="server" Text='<%#Eval("VendorID") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Store Qty." HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("GenStock")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Reorder Qty." HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("ReorderQty")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Date" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("RaisedDate")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Raised User" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("PRRaiseBy")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PO Qty." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPOQty" CssClass="ItDoseTextinputNum" Text='<%#Eval("RemQty") %>' runat="server" Width="50px" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbPOQty" runat="server" TargetControlID="txtPOQty" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="40px" HeaderText="Select" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemStyle VerticalAlign="Middle" />
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkPO" runat="server" Text="" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Purchase Order Information
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                PO Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPODate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtPODate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Valid Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtValidDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtValidDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPOType" runat="server" OnSelectedIndexChanged="ddlPOType_SelectedIndexChanged" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Delivery Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDeliveryDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" TargetControlID="txtDeliveryDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemarks" runat="server" CssClass="ItDoseTextinputText" TextMode="MultiLine" />
                            <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText" ValidationGroup="Save" Width="300px" Style="display: none;" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" FilterType="Custom, Numbers" TargetControlID="txtFreight" ValidChars="."></cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="display: none">
                    <td>Freight :
                    </td>
                    <td>
                        <asp:TextBox ID="txtFreight" runat="server" Width="75px" CssClass="ItDoseTextinputNum" />
                    </td>
                    <td>R/o Amt.(+ -)&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtRoundOff" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                            Width="75px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                            TargetControlID="txtRoundOff" FilterType="Custom, Numbers" ValidChars=".-">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>Scheme&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtScheme" runat="server" CssClass="ItDoseTextinputNum" Text="0" Width="75px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                            TargetControlID="txtScheme" FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>Bill Amount&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtInvoiceAmount" runat="server" Width="75px" CssClass="ItDoseTextinputNum"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtInvoiceAmount" FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                        <asp:TextBox ID="lbl" runat="server" meta:resourcekey="lblResource1"></asp:TextBox>
                    </td>
                </tr>
                <tr style="display: none">
                    <td>Excise On Bill&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtExciseOnBill" Width="75px" Text="0" CssClass="ItDoseTextinputNum" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server"
                            TargetControlID="txtExciseOnBill" FilterType="Custom, Numbers" ValidChars=".-">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
            </table>
            <div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <asp:Label ID="lblchktxt" runat="server" Text="Print:"></asp:Label>
            <asp:CheckBox ID="chkPrintImg" Checked="true" runat="server" />
            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="RestrictDoubleEntry(this);" />
        </div>
    </div>

</asp:Content>

