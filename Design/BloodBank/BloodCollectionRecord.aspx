<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="BloodCollectionRecord.aspx.cs" Inherits="Design_BloodBank_BloodCollectionRecord" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
       <script type="text/javascript">
        $(function () {
            $('#txtdatefrom').change(function () {
                ChkDate();
            });
            $('#txtdateTo').change(function () {
                ChkDate();
            });
        });
       
        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtdatefrom').val() + '",DateTo:"' + $('#txtdateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdDonorList.ClientID %>').hide();
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
            <b>Blood Collection Report</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div   class="POuter_Box_Inventory">
            <table  style="width: 100%; border-collapse:collapse">
                <tr>
                    <td align="right" style=" width: 12%;" >
                        Donor ID :&nbsp;
                    </td>
                    <td align="left" style=" width: 25%;">
                        <asp:TextBox ID="txtDonorId" runat="server" MaxLength="30" Width="170px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbDonor" runat="server" FilterType="Numbers,LowercaseLetters,UppercaseLetters" TargetControlID="txtDonorId">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td align="right" style=" width: 15%;" >
                        Collection ID :&nbsp;
                    </td>
                    <td align="left" style=" width: 35%;">
                        <asp:TextBox ID="txtDonationId" runat="server" MaxLength="30" Width="170px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbCollection" runat="server" FilterType="Numbers,LowercaseLetters,UppercaseLetters"
                            TargetControlID="txtDonationId">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td align="right" style=" width: 12%;" >
                        Donor Name :&nbsp;
                    </td>
                    <td align="left" style=" width: 35%;">
                        <asp:TextBox ID="txtName" runat="server" MaxLength="50" Width="170px"></asp:TextBox>
                    </td>
                    <td align="right" style=" width: 25%;" >
                        Blood Group :&nbsp;
                    </td>
                    <td align="left" style=" width: 35%;">
                        <asp:DropDownList ID="ddlBloodgroup" runat="server"  Width="170px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right" style=" width: 12%;" >
                        Date From :&nbsp;
                    </td>
                    <td align="left" style=" width: 35%;">
                        <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static" Width="170px"> </asp:TextBox>
                        <cc1:CalendarExtender ID="caldatefrom" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td align="right" style=" width: 15%;" >
                        Date To :&nbsp;
                    </td>
                    <td align="left" style=" width: 35%;">
                        <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static" Width="170px"></asp:TextBox>
                        <cc1:CalendarExtender ID="caldateTo" TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
            </table>
        </div>
        <div  class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server" OnClick="btnSearch_Click" />
            <asp:Button ID="btnPrint" Text="Report" CssClass="ItDoseButton" runat="server" OnClick="btnPrint_Click" />
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div style="text-align: center;" class="POuter_Box_Inventory">
                <asp:GridView ID="grdDonorList" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor ID">
                            <ItemTemplate>
                                <asp:Label ID="lblVisitorID" runat="server" Text='<%# Eval("Visitor_ID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Height="20px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" Height="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection ID">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodCollectionID" runat="server" Text='<%#Eval("BloodCollection_ID")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tube No.">
                            <ItemTemplate>
                                <asp:Label ID="lblTubeNo" runat="server" Text='<%#Eval("bbtubeNo")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Volume">
                            <ItemTemplate>
                                <asp:Label ID="lblVolumn" runat="server" Text='<%#Eval("Volume")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection Date">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodCollectionID" runat="server" Text='<%#Eval("Collecteddate")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Blood Group">
                            <ItemTemplate>
                                <asp:Label ID="lblBG" runat="server" Text='<%#Eval("BloodGroup")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
