<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" CodeFile="LabObservationComments.aspx.cs" Inherits="Design_Investigation_InvComments" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <%--  <link href="../../Styles/grid24.css" rel="stylesheet" />--%>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div>
                <div style="text-align: center;">
                    <b>Create Comments Template<br />
                    </b>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" style="display:none;" />
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Observation&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div  >
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Observation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlObservation" runat="server"
                                AutoPostBack="True" OnSelectedIndexChanged="ddlObservation_SelectedIndexChanged" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Available Comments 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-12">
                            <asp:GridView ID="grdTemplate" runat="server" AutoGenerateColumns="False"
                                CssClass="GridViewStyle" OnRowCommand="grdTemplate_RowCommand">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Comments_Head" HeaderText="Comments Name">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Investigation" HeaderText="Investigation">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Reject">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandArgument='<%#Eval("Comments_ID") %>'
                                                CommandName="Reject" ImageUrl="~/Images/Delete.gif" />

                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="False" CommandArgument='<%# Eval("Comments_ID") %>'
                                                CommandName="vEdit" ImageUrl="~/Images/edit.png" />

                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                    </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div  >
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Comments Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCommentsName"  runat="Server" CssClass="ItDoseTextinputText requiredField" Visible="true" AutoCompleteType="Disabled"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Comments Desc
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18 requiredField">
                            <CKEditor:CKEditorControl ID="txtLimit" BasePath="~/ckeditor" runat="server"  EnterMode="BR"></CKEditor:CKEditorControl>
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" Width="56px" style="margin-top: 346px;" class="ItDoseButton" />
                        </div>
                    </div> 
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div> 
    <script>
        $('#ddlObservation').chosen();
    </script>
</asp:Content>


