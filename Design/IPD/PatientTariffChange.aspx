<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientTariffChange.aspx.cs"
    Inherits="Design_IPD_PatientTariffChange" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
  <script src="../../Scripts/Search.js" type="text/javascript"></script>
    <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
        <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" >

        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting....';
           
        }
        function validatespace() {
            var card = $('#<%=txtCHName.ClientID %>').val();
             if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                 $('#<%=txtCHName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                // $('#<%=lblMsg.ClientID %>').text('');
                return true;
            }

        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
            // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            var card = $('#<%=txtCHName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtCHName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function showhide() {
            if ($("#<%=ddlPanelCompany.ClientID %> option:selected").text() == 'CASH') {
                $('#<%=txtCardNo.ClientID %>').attr('readonly', 'readonly');
                $('#<%=txtCHName.ClientID %>').attr('readonly', 'readonly');
                $('#<%=txtEmpID.ClientID %>').attr('readonly', 'readonly');
                $('#<%=txtfile_no.ClientID %>').attr('readonly', 'readonly');
                $('#<%=txtPolicyNo.ClientID %>').attr('readonly', 'readonly');
                $('#<%=ddlHolder_Relation.ClientID %>').attr('disabled', 'disabled');
                
            }
            else {
                $('#<%=txtCardNo.ClientID %>').removeAttr('readonly');
                $('#<%=txtCHName.ClientID %>').removeAttr('readonly');
                $('#<%=txtEmpID.ClientID %>').removeAttr('readonly');
                $('#<%=txtfile_no.ClientID %>').removeAttr('readonly');
                $('#<%=txtPolicyNo.ClientID %>').removeAttr('readonly');
                $('#<%=ddlHolder_Relation.ClientID %>').removeAttr('disabled');
            }


        }
        $(document).ready(function () {
            showhide();
            $('#ddlBillCategory').chosen();
            $('#ddlPanelCompany').chosen();
        });

        function confirm_Tariff(btn) {
            if (confirm("Are You Sure to Proceed ?") == true) {
                btn.disabled = true;
                btn.value = 'Submitting...';
                __doPostBack('btnApproveRate', '');
                return true;
            }
            else {
                return false;
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Patient Tariff Modification/Differential Billing </b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <table  style="width: 97%;border-collapse:collapse">
                    <tr>
                        <td colspan="4" style="text-align: center; color:red;">
                            <asp:RadioButtonList ID="rbtChange" ForeColor="Red" runat="server" AutoPostBack="True" 
                                OnSelectedIndexChanged="rbtChange_SelectedIndexChanged" RepeatDirection="Horizontal" TabIndex="1" ToolTip="Click to Select">
                                <asp:ListItem Selected="True" Value="2">On Change of Billing Category</asp:ListItem>
                                <asp:ListItem Value="1">On Change of Panel</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%;text-align:right" >
                            
                            <asp:Label ID="lblCurrentName" runat="server"></asp:Label>
                        </td>
                        <td style="width: 30%">
                            &nbsp;<asp:Label ID="lbllCurrent" runat="server" Font-Bold="False"></asp:Label>
                        </td>
                        <td style="width: 20%;text-align:right" >
                            <asp:Label ID="lblName" runat="server" Text="Panel Name :"></asp:Label>
                        </td>
                        <td style="width: 26%">
                            &nbsp;<asp:DropDownList ID="ddlBillCategory" runat="server"  Width="86%"  ToolTip="Select Billing Category" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlBillCategory_SelectedIndexChanged">
                            </asp:DropDownList>
                           &nbsp;<asp:DropDownList ID="ddlPanelCompany" runat="server"  ToolTip="Select Case Type" onchange="showhide();"
                                Width="86%" AutoPostBack="True" OnSelectedIndexChanged="ddlPanelCompany_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div class="filterOpDiv" style="overflow: scroll; height: 234px; text-align: center">
                                <asp:GridView ID="grdPanelRate" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                    Width="100%">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Category" HeaderText="Category">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="CurrentGrossBill" HeaderText="Current Gross Bill">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="122px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="TotalDiscAmt" HeaderText="Total Disc. Amt.">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="116px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ProposedGrossBill" HeaderText="Proposed Gross Bill">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                        </asp:BoundField>
                                         <asp:BoundField DataField="ProposedDiscAmt" HeaderText="Proposed Panel Disc. Amt.">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="116px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="GrossAmtDiff" HeaderText="Diff. in Gross Amt.">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <br />
                                <asp:Label ID="lblPropesedTotal" runat="server" ForeColor="Blue" Font-Bold="true" Font-Size="10pt"></asp:Label><br />
                                <asp:Label ID="Label1" runat="server" ForeColor="Blue" Font-Bold="true" Font-Size="10pt">Note: Medicine & Consumables are not included in for Tariff Conversion..</asp:Label></div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <table style="width: 100%;border-collapse:collapse">
                    <tr>
                        <td style="width: 15%;text-align:right"  >
                           <%-- Staff ID :--%>&nbsp;
                        </td>
                        <td style="width: 35%">
                            &nbsp;
                            <asp:TextBox ID="txtEmpID" runat="server" CssClass="ItDoseTextbox" Width="224px"
                                MaxLength="30" TabIndex="1" ToolTip="Enter Staff ID" Visible="false"></asp:TextBox>
                        </td>
                        <td style="width: 15%;text-align:right"  >
                            Policy No. :&nbsp;
                        </td>
                        <td style="width: 35%">
                            <asp:TextBox ID="txtPolicyNo" runat="server" CssClass="required" Width="224px" 
                                MaxLength="30" TabIndex="2" ToolTip="Enter Policy No."></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%;text-align:right"  >
                            Card No. :&nbsp;
                        </td>
                        <td style="width: 35%">
                            <asp:TextBox ID="txtCardNo" runat="server" CssClass="required" Width="224px" 
                                MaxLength="30" TabIndex="3" ToolTip="Enter Card No."></asp:TextBox>
                                                        <cc1:FilteredTextBoxExtender ID="ftbcardNo" runat="server" TargetControlID="txtCardNo"  FilterType="Numbers"></cc1:FilteredTextBoxExtender>

                        </td>
                        <td style="width: 15%;text-align:right"  >
                            <%--Browse File :&nbsp;--%>
                            Card Holder Name :&nbsp;
                        </td>
                        <td style="width: 35%">
                            <asp:TextBox ID="txtCHName" runat="server" CssClass="required" Width="224px" onkeypress="return check(event)" onkeyup="validatespace();"
                                MaxLength="30" TabIndex="4" ToolTip="Enter Card Holder Name"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td  style="width: 15%;text-align:right" >
                            <%--File No. :--%>&nbsp;
                        </td>
                        <td style="width: 35%">
                            <asp:TextBox ID="txtfile_no" runat="server" CssClass="ItDoseTextbox" Width="224px"
                                MaxLength="30" TabIndex="5" ToolTip="Enter File No." Visible="false"></asp:TextBox>
                            <%--<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtfile_no"
                                 ErrorMessage="Only Number" ValidationExpression="^\d+$" SetFocusOnError="true"></asp:RegularExpressionValidator>--%>
                        </td>
                        <td  style="width: 15%;text-align:right" >
                            <%--Card Holder Name :&nbsp;--%>
                             Relation With CH :&nbsp;
                        </td>
                        <td style="width: 35%">
                        <asp:DropDownList ID="ddlHolder_Relation" runat="server" Width="240px" CssClass="required" TabIndex="6" ToolTip="Select Relation With Card Holder">
                            </asp:DropDownList>
                            <asp:FileUpload ID="FileUpload1" runat="server" CssClass="ItDoseTextbox" Width="224px"
                                Style="display: none" />
                        </td>
                    </tr>
                   
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory"  style="text-align: center;">
           
                &nbsp;<asp:CheckBox ID="chkTariff" runat="server" Text="Include Tariff Conversion" Visible="true"  />&nbsp;<asp:Button
                    ID="btnApproveRate" runat="server" CssClass="ItDoseButton" OnClick="btnApproveRate_Click"
                    OnClientClick="return confirm_Tariff(this);" Text="Update"  />&nbsp;<asp:Button
                        ID="btnCancelApproval" runat="server" CssClass="ItDoseButton" Text="Cancel"  /></div>
       
    </div>
    </form>
</body>
</html>
