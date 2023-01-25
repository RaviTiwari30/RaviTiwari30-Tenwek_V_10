<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientHistoryReport.aspx.cs" Inherits="Design_OPD_PatientHistoryReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnView').attr('disabled', 'disabled');
                        $('#<%=GridView1.ClientID %>').hide();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnView').removeAttr('disabled');
                    }
                }
            });

        }
        function validatespace() {
            var card = $('#<%=txtPatientName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtPatientName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                return true;
            }

        }

        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

           if (status == true) {
               $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
           }
           else {
               $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
           }
       }
       function chkCentreCon() {
           if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%=chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
    </script>
    
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient History</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;</div>
            <table  style="width: 100%; border-collapse:collapse">
                <tr>
                    <td style="width: 20%; text-align: right">
                        Receipt No. :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="txtReceiptNo" runat="server" Width="170px" TabIndex="1" ToolTip="Enter Receipt No."></asp:TextBox>
                    </td>
                    <td style="width: 20%; text-align: right">
                        Bill No. :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="txtBillNo" runat="server" Width="170px" TabIndex="2" ToolTip="Enter Bill No."></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">
                        Patient Name :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="txtPatientName" runat="server" 
                             Width="170px" TabIndex="3" ToolTip="Enter Patient Name"></asp:TextBox>
                    </td>
                    <td style="width: 20%; text-align: right">
                        UHID :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="txtRegNo" runat="server" Width="170px" TabIndex="4" ToolTip="Enter UHID"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">
                        From Date :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="170px"
                            ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">
                        To Date :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="ucToDate" runat="server" Width="170px" ClientIDMode="Static" TabIndex="6"
                            ToolTip="Click To Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">
                       <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" /></td>
                    <td style="text-align: left; width: 80%" colspan="3">
                          <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" 
RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                    </td>
                    
                    
                </tr>
                 
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                    <asp:Button ID="btnView" runat="server" CssClass="ItDoseButton"
                        TabIndex="7" Text="Search" OnClick="btnView_Click" ClientIDMode="Static"
                        ToolTip="Click To Search" />
            
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details </div>
            <div style="overflow: auto; padding: 3px; width: 950px; height: 340px;">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    AllowPaging="True" OnPageIndexChanging="GridView1_PageIndexChanging" CssClass="GridViewStyle">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:BoundField DataField="PName" HeaderText="Patient Name">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="TypeName" HeaderText="History">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                        </asp:BoundField>
                         <asp:BoundField DataField="TypeOfTnx" HeaderText="Visit">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                        </asp:BoundField>
                        
                         <asp:TemplateField HeaderText="Receipt No.">
                            <ItemTemplate>
                            <asp:Label ID="lblReceiptNo" runat="server" Text='<%# Eval("ReceiptNo") %>'></asp:Label>
                             </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bill No.">
                            <ItemTemplate>
                            <asp:Label ID="lblBillNo" runat="server" Text='<%# Eval("BillNo") %>'></asp:Label>
                             </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="Date" HeaderText="Date">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                        </asp:BoundField>
                         <asp:BoundField DataField="Time" HeaderText="Time">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AmountPaid" HeaderText="Bill Amt.">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px"  />
                        </asp:BoundField>
                        
                       
                       
                       
                    </Columns>
                </asp:GridView>
            </div>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
            
                    <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton"
                        TabIndex="8" Text="Report" ClientIDMode="Static" OnClick="btnReport_Click"
                        ToolTip="Click To Report" />
            
        </div>
            </asp:Panel>
    </div>
</asp:Content>

