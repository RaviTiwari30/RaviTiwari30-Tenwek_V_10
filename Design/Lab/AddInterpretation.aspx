<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" EnableEventValidation="false" CodeFile="AddInterpretation.aspx.cs" Inherits="Design_Lab_AddInterpretation" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <link href="../../Styles/grid24.css" rel="stylesheet" />
    <div id="Pbody_box_inventory" style="text-align: left;">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Add Interpretation<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Investigation
            </div>
                  <div class="row">
                <div class="col-md-1"></div>
                <div  >
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Investigation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:DropDownList ID="ddlInvestigation" runat="server" class="requiredField" Width="95%" OnSelectedIndexChanged="ddlInvestigation_SelectedIndexChanged" AutoPostBack="true">
                        </asp:DropDownList>
                        <%--<asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                        </div>
                    </div>
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Interpretation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                         <ckeditor:ckeditorcontrol ID="txtInvInterpretaion"  BasePath="~/ckeditor" runat="server" EnterMode="BR"  ></ckeditor:ckeditorcontrol>
                        </div>
                          <div class="col-md-2">
                               <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton" style="  width: 56px;    margin-top: 346px;" />
                          </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="display:none;" >
                <tr>
                    <td style=" width: 36%; text-align: left">
                        <asp:DropDownList ID="ddlMachineName" runat="server"  Visible="false"></asp:DropDownList>
                    </td>
                </tr>
              
            </table>
        </div> 
    </div>
    <script>
        $(document).ready(function () {
            $('#<%=ddlInvestigation.ClientID%>').chosen(); 
        });
    </script>
</asp:Content>
