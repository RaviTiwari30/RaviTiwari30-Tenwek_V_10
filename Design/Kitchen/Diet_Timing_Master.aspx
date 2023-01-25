<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Diet_Timing_Master.aspx.cs" Inherits="Design_Kitchen_Diet_Timing_Master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            var MaxLength = 200;
            $('#<%=txtDesc.ClientID %>').keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    e.preventDefault();
                }
            });
        });
        function validate(btn) {
            if ($.trim($("#<%=txtTimingName.ClientID%>").val()) == "") {
                $("#<%=lblmsg.ClientID%>").text('Please Enter Timing Name');
                modelAlert('Please Enter Timing Name');
                $("#<%=txtTimingName.ClientID%>").focus();
                return false;
            }
            if ($("#<%=ddlOrderBefore.ClientID%>").val() == "Select") {
                $("#<%=lblmsg.ClientID%>").text('Please Provide Order Before Hours');
                modelAlert('Please Provide Order Before Hours');
                $("#<%=ddlOrderBefore.ClientID%>").focus();
                return false;
            }
            btn.disabled = true;
            btn.value = 'Submitting....';
            if ($("#<%=btnsave.ClientID%>").is(':visible'))
                __doPostBack('ctl00$ContentPlaceHolder1$btnsave', '');
            else
                __doPostBack('ctl00$ContentPlaceHolder1$btnUpdate', '');
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Diet Timing Master<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" style="display:none"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Master</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FromTime" runat="server"
                                MaxLength="5" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="FromTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" InvalidValueMessage="Please Enter Valid Time" EmptyValueMessage="Please Enter Time"
                                IsValidEmpty="false" ControlExtender="MaskedEditExtender2" ControlToValidate="FromTime" runat="server"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToTime" runat="server"
                                MaxLength="5" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="ToTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" InvalidValueMessage="Please Enter Valid Time" EmptyValueMessage="Please Enter Time"
                                IsValidEmpty="false" ControlExtender="MaskedEditExtender1" ControlToValidate="ToTime" runat="server"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Timing Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTimingName" CssClass="requiredField" runat="server" MaxLength="100"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDesc" runat="server" MaxLength="100" TextMode="MultiLine"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order Before (Hr)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlOrderBefore" runat="server" CssClass="requiredField">
                                <asp:ListItem>Select</asp:ListItem>
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                                <asp:ListItem>13</asp:ListItem>
                                <asp:ListItem>14</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>16</asp:ListItem>
                                <asp:ListItem>17</asp:ListItem>
                                <asp:ListItem>18</asp:ListItem>
                                <asp:ListItem>19</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>21</asp:ListItem>
                                <asp:ListItem>22</asp:ListItem>
                                <asp:ListItem>23</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IsActive
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="true" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">DeActive</asp:ListItem>
                            </asp:RadioButtonList>
                            <div style="display: none;">
                                <asp:Label ID="lblId" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button runat="server" ID="btnsave" Text="Save" CssClass="ItDoseButton" OnClick="btnsave_Click" OnClientClick="return validate(this)" />
            <asp:Button runat="server" ID="btnUpdate" Text="Update" CssClass="ItDoseButton" Visible="false" OnClick="btnUpdate_Click" OnClientClick="return validate(this)" />
            <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" OnClick="btnCancel_Click" />
        </div>
        <asp:Panel ID="pnlHide" Visible="false" runat="server">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <div class="Purchaseheader">Diet Timing Detail</div>

                <div class="Content" style="text-align: center;">
                    <asp:GridView ID="grdDetail" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdDetail_SelectedIndexChanged">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="TimeName" HeaderText="Time Name" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                            </asp:BoundField>

                            <asp:BoundField DataField="Description" HeaderText="Description" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FromTime" HeaderText="From Time" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ToTime" HeaderText="To Time" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="OrderBefore" HeaderText="Order Before" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Active">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive")%>'></asp:Label>
                                    <div style="display: none;">
                                        <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("id")%>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:CommandField ShowSelectButton="True" ButtonType="Image" SelectImageUrl="~/Images/edit.png" SelectText="Edit" HeaderText="Edit">

                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                            </asp:CommandField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>

    </div>
</asp:Content>
