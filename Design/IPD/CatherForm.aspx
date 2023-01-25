<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CatherForm.aspx.cs" Inherits="Design_IPD_CatherForm" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
  
<html xmlns="http://www.w3.org/1999/xhtml">
<head  id="Head1"  runat="server">
    <title></title>
     <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/searchableDroplist.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <style type="text/css">
        auto-style7 {
        font-size:10px;
        }
        .auto-style6 {
            width: 251px;
        }
        .auto-style7 {
            width: 188px;
        }
        .auto-style8 {
            width: 230px;
        }
    </style>
     <script type="text/javascript" >
         </script>
</head>
<body>
    <form id="form1" runat="server">
     <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
           <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>CATHETER ASSOCIATED URINARY INFECTION
                </b>
                <br />
                <span id="spnMsg" class="ItDoseLblError"></span>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblPatientID" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>
                <asp:Label ID="lblTransactionID" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>
            </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader" style="text-align: left;">
                      CATHETER ASSOCIATED URINARY INFECTION
                    </div>
                            <div>
                                <table>
                                     <tr>
                                         <td class="auto-style7" style="text-align:right">Inserted By :&nbsp</td>
                                         <td class="auto-style8"><asp:DropDownList ID="ddlInsertUser" runat="server" Width="225px"></asp:DropDownList></td>
                                         <td class="auto-style6" style="text-align:right">Removed By :&nbsp;</td>
                                         <td><asp:DropDownList ID="ddlRemovedBy" runat="server" Width="225px" Enabled="false"></asp:DropDownList></td>
                                     </tr>
                                     <tr>
                                         <td class="auto-style7" style="text-align:right">Insert Date :&nbsp;</td>
                                         <td class="auto-style8"><asp:TextBox ID="txtInsertDate" ReadOnly="true" runat="server"></asp:TextBox>
                                             <cc1:CalendarExtender ID="cclInsertDate" runat="server" TargetControlID="txtInsertDate"
                                Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                         </td>
                                         <td class="auto-style6" style="text-align:right">Removed Date :&nbsp;</td>
                                         <td><asp:TextBox ID="txtRemovedDate" runat="server" ReadOnly="true" Enabled="false"></asp:TextBox>
                                             <cc1:CalendarExtender ID="cclRemovedDate" runat="server" TargetControlID="txtRemovedDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                         </td>
                                     </tr>
                                     <tr>
                                         <td class="auto-style7" style="text-align:right">Insert Time :&nbsp;</td>
                                         <td class="auto-style8"><asp:TextBox ID="txtInsertTime" runat="server"></asp:TextBox>
                                               <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtInsertTime"
                            Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtInsertTime"
                                ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                         </td>
                                         <td class="auto-style6" style="text-align:right">Removed Time :&nbsp;</td>
                                         <td><asp:TextBox ID="txtRemovedTime" runat="server" Enabled="false"></asp:TextBox>
                                               <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtRemovedTime"
                            Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtRemovedTime"
                                ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                         </td>
                                     </tr>
                                     <tr>
                                         <td class="auto-style7" style="text-align:right">Any Sign Infection :&nbsp;</td>
                                         <td class="auto-style8"><asp:TextBox ID="txtInfection" runat="server" Enabled="false" TextMode="MultiLine" Width="300px"></asp:TextBox></td>
                                         <td class="auto-style6" style="text-align:right">Infection Control Nurse :&nbsp;</td>
                                         <td><asp:DropDownList ID="ddlUser" runat="server" Width="225px" Enabled="false"></asp:DropDownList></td>
                                     </tr>
                                     </table>
                                <div style="text-align:center"><asp:Button ID="btnSaveInsertion" runat="server" Text="Save" ValidationGroup="save1" CssClass="ItDoseButton" OnClick="btnSaveInsertion_Click" /></div>
                                </div>
                    <div class="POuter_Box_Inventory" style="text-align: center;">
                <table style="width: 100%" id="tb_Record" runat="server" visible="false">
                    <tr>
                        <td style="text-align: right">Date :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:Label ID="lblcathID" runat="server" Visible="false"></asp:Label>
                            <asp:DropDownList ID="ddlDays" runat="server" OnTextChanged="ddlDays_TextChanged" AutoPostBack="true">
                                <asp:ListItem Value="1">1 Day</asp:ListItem>
                                <asp:ListItem Value="2">2 Day</asp:ListItem>
                                <asp:ListItem Value="3">3 Day</asp:ListItem>
                                <asp:ListItem Value="4">4 Day</asp:ListItem>
                                <asp:ListItem Value="5">5 Day</asp:ListItem>
                                <asp:ListItem Value="6">6 Day</asp:ListItem>
                                <asp:ListItem Value="7">7 Day</asp:ListItem>
                                <asp:ListItem Value="8">8 Day</asp:ListItem>
                                <asp:ListItem Value="9">9 Day</asp:ListItem>
                                <asp:ListItem Value="10">10 Day</asp:ListItem>
                                <asp:ListItem Value="11">11 Day</asp:ListItem>
                                <asp:ListItem Value="12">12 Day</asp:ListItem>
                                <asp:ListItem Value="13">13 Day</asp:ListItem>
                                <asp:ListItem Value="14">14 Day</asp:ListItem>
                                <asp:ListItem Value="15">15 Day</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:GridView ID="grdCath" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="960px" OnRowDataBound="grdCath_RowDataBound" >
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                            <asp:Label ID="lblcatherID" runat="server" Text='<%#Eval("catherID") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblCatherName" runat="server" Text='<%#Eval("Name") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblDID" runat="server" Text='<%#Eval("DID") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                        </ItemTemplate>

                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Name" HeaderText="Cauthi Bundle" HeaderStyle-Width="200px" 
                                        ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center"/>
                                    <asp:TemplateField HeaderText="Day" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center" >
                                        <ItemTemplate>
                                            <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%#Eval("Status") %>'></asp:Label>
                                            <asp:Label ID="lblEntryBy" runat="server" Visible="false" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                            <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="2">
                                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                       <asp:TemplateField HeaderText="Remarks" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                          <asp:TextBox ID="txtRemarks" runat="server" Width="300px" Text='<%#Eval("Remarks") %>' ></asp:TextBox>
                                        </ItemTemplate>
                                           <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:TemplateField>
                                      <asp:BoundField DataField="EmpName" HeaderText="Entry By" HeaderStyle-Width="200px" 
                                        ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center"/>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;" id="div_Save" runat="server" visible="false">
                         <asp:Button ID="btnSaveDetail" OnClick="btnSaveDetail_Click" runat="server"
                    CssClass="ItDoseButton" Text="Save" />
            </div>
                </div>
    </div>
    </form>
</body>
</html>
