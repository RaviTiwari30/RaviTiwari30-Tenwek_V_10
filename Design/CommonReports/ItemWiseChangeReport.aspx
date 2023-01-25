<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ItemWiseChangeReport.aspx.cs" Inherits="Design_EDP_ItemWiseChangeReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />

    <style type="text/css">
        /*.htDimmed {
            background-color: antiquewhite !important;
            color: #0e0e0e !important;
        }*/


        .ht_clone_top {
            z-index: 0 !important;
        }

        .ht_clone_left {
            z-index: 0 !important;
        }

        #container.handsontable table {
            width: 100%;
        }
    </style>


    <script type="text/javascript">
        $(function () {
            getCategorys(function () {
                getSubCategorys($('#ddlCategory').val());
            });
        });
        var getCategorys = function (callback) {
            serverCall('ItemWiseChangeReport.aspx/GetAllCategory', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlCategory').bindDropDown({ data: JSON.parse(response).reverse(), valueField: 'CategoryID', textField: 'Name' }));
            });
        }


        var getSubCategorys = function (categoryID) {
            serverCall('ItemWiseChangeReport.aspx/GetSubCategoryByCategory', { categoryID: categoryID }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSubCategory').bindDropDown({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', defaultValue: 'All' });
            });
        }

      
    </script>






    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b> Item Wise Report</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select onchange="getSubCategorys(this.value)" id="ddlCategory"></select>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">SubCategory </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <select id="ddlSubCategory"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Item Name </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-5">
                    <input type="text" id="txtItemName" />
                </div>


            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Additional Search Criteria
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="width: 10%; text-align: left; border: groove">Type</td>
                    <td style="text-align: left; width: 100%; border: groove" colspan="6">
                        <div style="text-align: left;" class="scroll">
                            <asp:RadioButtonList ID="rbtActive" runat="server" RepeatDirection="Vertical" RepeatColumns="4">
                                <asp:ListItem Selected="True" Value="1">Vendor Wise  </asp:ListItem>
                                <asp:ListItem Value="2">Manufacturing Wise</asp:ListItem>
                                <asp:ListItem Value="3">MRP Wise</asp:ListItem>
                                <asp:ListItem Value="4">RATE Wise</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </td>
                </tr>
            </table>

            &nbsp;
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-8"></div>
                <div class="col-md-8 textCenter">
                    <input type="button" value="Report" class=" save" onclick="searchItems(function () { });" id="btnSearch" />
                </div>
            </div>
        </div>

    </div>

    

    

    <script type="text/javascript">

        var searchItems = function () {
            serverCall('ItemWiseChangeReport.aspx/getItem', { categoryId: $("#ddlCategory").val(), subCategoryId: $("#ddlSubCategory").val(), ItemName: $("#txtItemName").val(), Report_type:  $('#<%=rbtActive.ClientID %> input[type=radio]:checked').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    window.open(responseData.output);
                }
            });
        }

    </script>



</asp:Content>

