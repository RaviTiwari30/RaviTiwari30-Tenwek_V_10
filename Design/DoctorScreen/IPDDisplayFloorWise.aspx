<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDDisplayFloorWise.aspx.cs" Inherits="Design_DoctorScreen_IPDDisplayFloorWise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b><span id="lblHeader">Floor Wise IPD Ward Display</span></b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-2">
                            </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <b>Floor</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList  ID="ddlFloor" CssClass="requiredField" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <input type="button" value="Display" style="width:100px;" onclick="displayWardDisplay()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>

        var displayWardDisplay = function () {

            window.open('../DoctorScreen/DisplayWardScreen.aspx?floor=' + $('#ddlFloor').val());

        }

    </script>
</asp:Content>

