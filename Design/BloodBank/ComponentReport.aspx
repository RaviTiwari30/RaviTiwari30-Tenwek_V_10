<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ComponentReport.aspx.cs" Inherits="Design_BloodBank_ComponentReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
<script type = "text/javascript">
    $(function () {
        $('#txtcollectionfrom').change(function () {
            ChkDate();
        });
        $('#txtcollectionTo').change(function () {
            ChkDate();
        });
    });
    function ChkDate() {
        $.ajax({
            url: "../common/CommonService.asmx/CompareDate",
            data: '{DateFrom:"' + $('#txtcollectionfrom').val() + '",DateTo:"' + $('#txtcollectionTo').val() + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (data == false) {
                    $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                    $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').prop('disabled', 'disabled');
                    $('#<%=grdComponent.ClientID %>').hide();

                }
                else {
                    $('#<%=lblerrmsg.ClientID %>').text('');
                    $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').removeProp('disabled');
                }
            }
        });
    }

            </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Blood Component Report</b><br />
                <asp:Label id="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
           
        </div>
       
            <div id="dvSearch" runat="server" class="POuter_Box_Inventory">
                <div class="content">
                    <table cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            
                            <td align="right" style=" width: 20%;" class="ItDoseLabel">
                                Collection ID :&nbsp;
                            </td>
                            <td align="left" style=" width: 20%;">
                                <asp:TextBox ID="txtCollectionID" runat="server" MaxLength="30"  Width="170px"></asp:TextBox>
                       <cc1:FilteredTextBoxExtender ID="ftbCollection" runat ="server" FilterType ="Numbers,LowercaseLetters,UppercaseLetters" TargetControlID ="txtCollectionID"></cc1:FilteredTextBoxExtender>

                            </td>
                        </tr>
                        <tr>
                            <td align="right" style=" width: 20%;" class="ItDoseLabel">
                               Collection Date From :&nbsp;
                            </td>
                            <td align="left" style=" width: 20%;">
                            <asp:TextBox ID="txtcollectionfrom" runat="server" ClientIDMode="Static"  Width="170px"></asp:TextBox>
                        <cc1:calendarextender ID="calcollectionfrom" 
                            TargetControlID="txtcollectionfrom" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:calendarextender>
                               <%-- <uc1:EntryDate ID="EntryDate1" runat="server" />--%>
                            </td>
                            <td align="right" style=" width: 20%;" class="ItDoseLabel">
                              Collection Date To :&nbsp;
                            </td>
                            <td align="left" style=" width: 20%;">
                             <asp:TextBox ID="txtcollectionTo" runat="server" ClientIDMode="Static" Width="170px"></asp:TextBox>
                        <cc1:calendarextender ID="calcollectionTo" 
                            TargetControlID="txtcollectionTo" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:calendarextender>
                                <%--<uc1:EntryDate ID="EntryDate2" runat="server" />--%>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="dvBtn2" runat="server" class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server"
                        OnClick="btnSearch_Click" />
                    <asp:Button ID="btnPrint" Text="Report" CssClass="ItDoseButton" runat="server"
                        OnClick="btnPrint_Click" />
                </div>
            </div>
            <asp:Panel ID="pnlHide" runat="server" Visible="false" >
            <div id="dvDonor" runat="server" class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <asp:GridView ID="grdComponent" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false"
                        >
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="Collection ID">
                                <ItemTemplate>
                                    <asp:Label ID="lblBloodCollectionID" runat="server" Text='<%#Eval("BloodCollection_ID")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Component Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblComponentName" runat="server" Text='<%#Eval("ComponentName")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Bag Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblBagType" runat="server" Text='<%#Eval("BagType")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:TemplateField>
                           
                            <asp:TemplateField HeaderText="Created By">
                                <ItemTemplate>
                                    <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Created Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblCreatedDate" runat="server" Text='<%#Eval("CreatedDate")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                            </asp:TemplateField>                         
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            </asp:Panel>     
    </div>
</asp:Content>

