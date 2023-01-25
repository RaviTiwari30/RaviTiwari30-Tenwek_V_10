<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OPDFinalSettlement.aspx.cs"
    Inherits="Design_OPD_OPDFinalSettlement" MasterPageFile="~/DefaultHome.master"
    MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Src="~/Design/Controls/wuc_ipdAdvance.ascx" TagName="PaymentControl"
    TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >
        $(document).ready(function () {
            if (('<%=GetGlobalResourceObject("Resource", "TaxRequired") %>') == "0")
                $("#lblGovTaxAmt,#lblGovTax").hide();
            else
                $("#lblGovTaxAmt,#lblGovTax").show();
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

        $(document).ready(function () {
            $('#txtFromDate').change(function () {
                ChkDate();

            });

            $('#txtToDate').change(function () {
                ChkDate();
            });

        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnView').attr('disabled', 'disabled');
                        $("#<%= pnlHideSettlement.ClientID%>,#<%= pnlOPDFinalSettlement.ClientID%>").hide();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnView').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {
            if (($.trim($('#<%= PaymentControl.FindControl("ddlPaymentMode").ClientID %>').val()) != "4") && ($('#<%= PaymentControl.FindControl("grdPaymentMode").ClientID %> tr').length == "0")) {
                if ($.trim($('#<%= PaymentControl.FindControl("txtPaidAmount").ClientID %>').val()) > "0") {
                    $('#<%=lblMsg.ClientID %>').text('Please Add Amount');
                    $('#<%= PaymentControl.FindControl("btnAdd").ClientID %>').focus();
                }
                else {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Amount');
                    $('#<%= PaymentControl.FindControl("txtPaidAmount").ClientID %>').focus();
                }
                return false;
            }
            if (($('select[id*=ddlPaymentMode]').val() == "2") || ($('select[id*=ddlPaymentMode]').val() == "3")) {
                if ($('#<%=PaymentControl.FindControl("ddlBank").ClientID %>').val() == "") {
                    $("#<%=lblMsg.ClientID %>").text('Please Select Bank Name');
                    $('#<%=PaymentControl.FindControl("ddlBank").ClientID %>').focus();
                    return false;
                }
                if ($.trim($('#<%=PaymentControl.FindControl("txtrefNo").ClientID %>').val()) == "") {
                    $("#<%=lblMsg.ClientID %>").text('Please Enter Card/Ref. No.');
                    $('#<%=PaymentControl.FindControl("txtrefNo").ClientID %>').focus();
                    return false;
                }

            }
            var NetAmount = ($('#<%= PaymentControl.FindControl("txtNetAmount").ClientID %>').val());
            var RoundVal = ($('#<%= PaymentControl.FindControl("lblRoundVal").ClientID %>').text());
            var amt = precise_roundamt(eval(NetAmount) + eval(RoundVal), 2);
            
           // alert($('#<%= PaymentControl.FindControl("lblRoundVal").ClientID %>').text());
           // alert(eval(($('#<%= PaymentControl.FindControl("txtNetAmount").ClientID %>').val())) + eval(($('#<%= PaymentControl.FindControl("lblRoundVal").ClientID %>').text())));
           // alert(parseFloat($.trim($('#<%= PaymentControl.FindControl("lblTotalPaidAmount").ClientID %>').text())));
            if (amt != parseFloat($.trim($('#<%= PaymentControl.FindControl("lblTotalPaidAmount").ClientID %>').text()))) {
              //  $('#<%=lblMsg.ClientID %>').text('Paid amount cannot less than Net Bill amount');
              //  return false;
            }

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
        function precise_roundamt(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        $(document).ready(function () {
            $('#<%= PaymentControl.FindControl("btnAdd").ClientID %>').prop("disabled", "disabled");
        //  var total = $("#<%=txtAmount.ClientID %>").val();
        //  $("input[id*=txtNetAmount]").val(total);
        //  CallUserControlFn($("select[id*=ctl00_ContentPlaceHolder1_PaymentControl_ddlCountry]").val(), $("span[id*=lblBalanceAmount]").text());
            $('#<%= PaymentControl.FindControl("txtPaidAmount").ClientID %>').bind("blur keyup keydown", function () {
                if ($("input[id*=txtPaidAmount]").val() > "0" ) {
                    $("input[id*=btnAdd]").attr("disabled", false);
                }
                else {
                    $("#<%=btnSave.ClientID %>").attr("disabled", true);
                    $("input[id*=btnAdd]").attr("disabled", true);
                }
            });

        });
        function CallUserControlFn(CountryID, Amount) {
            $.ajax({
                url: "../Common/CommonService.asmx/getConvertCurrecncy",
                data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;

                    data = data = parseFloat(data) + parseFloat($('#<%= PaymentControl.FindControl("txtCurrencyRoffAmt").ClientID %>').val());
                        $("span[id*=ctl00_ContentPlaceHolder1_PaymentControl_lblCurrencyBase]").text(data + ' ' + $("input[id*=ctl00_ContentPlaceHolder1_PaymentControl_lblCurrencyNotation]").val());
                        $('#<%= PaymentControl.FindControl("txtCurrencyBase").ClientID %>').val(data);
                    }
                });
            }
    </script>
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="ScriptManager1" runat="server">
        </ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Final Settlement</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server"></asp:TextBox>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <table style="width: 90%;border-collapse:collapse">
                <tr style="text-align: center">
                    <td style="width: 10%; text-align: center;" colspan="5"></td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right;">UHID :&nbsp;
                    </td>
                    <td style="width: 15%; text-align: left; ">
                        <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled" TabIndex="1"
                            ToolTip="Enter UHID"></asp:TextBox>
                    </td>
                    <td style="width: 15%; text-align: right; ">Panel :&nbsp;
                    </td>
                    <td style="width: 15%; text-align: left; ">
                        <asp:DropDownList ID="ddlPanelCompany" Width="156px" runat="server" ToolTip="Select Panel" TabIndex="2">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right; ">From Date :&nbsp;
                    </td>
                    <td style="width: 15%; text-align: left">
                        <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 15%; text-align: right; ">To Date :&nbsp;
                    </td>
                    <td style="width: 15%; text-align: left">
                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 15%; text-align: left">
                       
                    </td>
                </tr>
            </table>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
              <asp:Button ID="btnView" runat="server" CssClass="ItDoseButton" OnClick="btnView_Click"
                            TabIndex="3" Text="Search" ClientIDMode="Static" />
             </div>
        <asp:Panel ID="pnlHideSettlement" runat="server"  Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Details
                </div>
                <div style="padding: 3px; overflow: auto; width: 950px; height: 200px; text-align: center">
                    <asp:GridView ID="grdBill" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnSelectedIndexChanged="grdBill_SelectedIndexChanged">
                        <Columns>
                            <asp:BoundField DataField="BillDate" HeaderText="Bill Date">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="90px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle"  HorizontalAlign="Center"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="PatientName" HeaderText="Patient Name">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="200px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="UHID" >
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px"  HorizontalAlign="Center"/>
                                <ItemTemplate>
                                    <asp:Label ID="lblMRNo" Text='<%#Util.GetString(Eval("patientid")) %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="NetAmount" HeaderText="Bill Amt.">
                                <ItemStyle HorizontalAlign="right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PaidAmt" HeaderText="Paid Amt.">
                                <ItemStyle HorizontalAlign="right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Pending Amt.">
                                <ItemTemplate>
                                    <asp:Label ID="lblPendingAmt" runat="server" Text='<%# Eval("PendingAmt") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="CompanyName" HeaderText="Panel">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="200px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:CommandField ButtonType="Image" HeaderText="Select" SelectImageUrl="~/Images/Post.gif"
                                ShowSelectButton="True">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:CommandField>
                            <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblLedTnxNo" runat="server" Text='<%# Eval("LedgertransactionNo") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("PatientID") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblPanelID" runat="server" Text='<%# Eval("PanelID") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("TransactionID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblPaidType" runat="server" Text='<%# Eval("PaidType") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblRoundOff" runat="server" Text='<%# Eval("RoundOff") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblNetAmtBeforeTax" runat="server" Text='<%# Eval("NetAmtBeforeTax") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblGovtaxAmount" runat="server" Text='<%# Eval("GovtaxAmount") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblTypeOfTnx" runat="server" Text='<%# Eval("TypeOfTnx") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblDeptLedgerNo" runat="server" Text='<%# Eval("DeptLedgerNo") %>' Visible="False"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <HeaderStyle HorizontalAlign="Left" />
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlOPDFinalSettlement" runat="server" Width="901px" Visible="false">
            <asp:Label ID="lblOPDFinalSettlement" runat="server" Style="display: none"></asp:Label>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Receipt Details&nbsp;
                </div>
                <table style="width: 100%; text-align: center">
                    <tr>
                        <td style="width: 13%; text-align: right">Patient Name :
                        </td>
                        <td style="width: 40%; text-align: left">
                            <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td style="width: 10%; text-align: right">UHID :
                        </td>
                        <td style="width: 40%; text-align: left">
                            <asp:Label ID="lblMRNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>

                    </tr>
                    <tr>
                        <td style="width: 13%; text-align: right">Net Amount :</td>
                        <td style="width: 40%; text-align: left"><asp:Label ID="lblNetAmtBeforeTax" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="width: 10%; text-align: right">
                            <asp:Label ID="lblGovTaxAmt" ClientIDMode="Static" runat="server" Text="Gov.&nbsp;Tax&nbsp;Amount&nbsp;:"></asp:Label>
                                Paid By :&nbsp;
                                
                                
                             </td>
                        <td style="width: 40%; text-align: left">
                            <asp:Label ID="lblPaidBy" ClientIDMode="Static" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblGovTax" ClientIDMode="Static" runat="server"></asp:Label> </td>
                    </tr>
                    <tr>
                        <td style="width: 13%; text-align: right">
                            Round Off :
                        </td>
                        <td style="width: 40%; text-align: left">
                            <asp:Label ID="lblRoundOff" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td style="width: 10%; text-align: right"><asp:Label ID="lblAmtType" runat="server" Visible="False"></asp:Label></td>
                        <td style="width: 40%; text-align: left"><asp:Label ID="lblAmtSum" runat="server" Visible="False" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblPanelID1" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblLedgertransactionNo" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblTransactionID" runat="server" Visible="false"></asp:Label>
                        </td>
                        
                    </tr>
                    <tr>
                        <td style="width: 13%; text-align: right">OPD Advance : </td>
                        <td style="width: 40%; text-align: left"><asp:Label ID="lblOPDAdvance" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td style="width: 10%; text-align: right">
                           &nbsp;
                                
                                
                             </td>
                        <td style="width: 40%; text-align: left">
                           &nbsp; </td>
                    </tr>
                    <tr>
                        <td style="width: 13%; text-align: right">Amount :
                        </td>
                        <td style="width: 40%; text-align: left">
                            <asp:TextBox ID="txtAmount" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum"
                                TabIndex="3" Width="94px" ReadOnly="True"></asp:TextBox>
                        </td>
                        <td style="width: 10%; text-align: right"></td>
                        <td style="width: 40%; text-align: left"></td>

                    </tr>
                    <tr>
                        <td style="width: 13%; text-align: right">
                            <asp:CheckBox ID="chkRefund" runat="server" Text="REFUND" Visible="False" />

                        </td>
                        <td style="width: 40%; text-align: left"></td>
                        <td style="width: 10%; text-align: right"><asp:Label ID="lblTypeOfTnx" runat="server" Visible="false"></asp:Label>
                            <asp:Label ID="lblDeptLedgerNo" runat="server" Visible="false"></asp:Label>
                        </td>
                        <td style="width: 40%; text-align: left"></td>

                    </tr>
                </table>
                <table style="width: 100%; text-align: center">
                    <tr>
                        <td style="text-align: left" colspan="4">
                            <uc:PaymentControl ID="PaymentControl" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 13%; text-align: right; vertical-align: top">Narration :
                        </td>
                        <td colspan="3" style="text-align: left">
                            <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" Width="248px"></asp:TextBox>
                        </td>


                    </tr>
                </table>
                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                    ValidChars="-,." TargetControlID="txtAmount">
                </cc1:FilteredTextBoxExtender>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">


                <asp:Button ID="btnSave" runat="server" AccessKey="s" CssClass="ItDoseButton" OnClick="btnSave_Click"
                    OnClientClick="return RestrictDoubleEntry(this);" TabIndex="5" Text="Save" UseSubmitBehavior="false" />&nbsp;
            </div>


        </asp:Panel>
    </div>
</asp:Content>
