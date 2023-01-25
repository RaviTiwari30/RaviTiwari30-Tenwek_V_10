<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DepreciationReport.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_Asset_DepreciationReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">
        $(document).ready(function () {
            loadGroup(function (GroupID) {
                loadItems(GroupID, function () {

                });
            });
        });

        var loadGroup = function (callback) {
            ddlGroup = $('#ddlGroup');
            serverCall('Services/WebService.asmx/loadGroup', {}, function (response) {
                ddlGroup.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'SubCategoryName', isSearchAble: true });
                callback(ddlGroup.val());
            });
        }
        var loadItems = function (GroupID, callback) {
            ddlItem = $('#ddlItem');
            serverCall('Services/WebService.asmx/loadAllAssetItems', { GroupID: GroupID }, function (response) {
                ddlItem.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ItemID', textField: 'ItemName', isSearchAble: true });
                callback(ddlItem.val());
            });
        }
        var Search = function () {
            data = {
                SubcategoryID: $('#ddlGroup').val(),
                ItemID: $('#ddlItem').val(),
                FromDate: $('#txtFromDate').val().trim(),
                ToDate: $('#txtToDate').val().trim(),
            }
            serverCall('DepreciationReport.aspx/GetDepretiationReport', data, function (response) {
                var responseData = JSON.parse(response);
                window.open(responseData.responseURL);
            });
        }
    </script>


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Depreciation Report</b>
            <span style="display: none" id="spnDepreciationID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Group Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlGroup" onchange="loadItems(this.value, function () {});"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlItem"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Purchase Dt</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                              <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Purchase Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                              <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div class="POuter_Box_Inventory">
             <div class="row" style="text-align:center">
                 <input type="button" id="btnSearch" value="Search" onclick="Search()" />
             </div>
         </div>
    </div>
</asp:Content>
