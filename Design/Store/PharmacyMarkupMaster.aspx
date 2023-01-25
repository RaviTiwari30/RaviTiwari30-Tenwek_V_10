<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PharmacyMarkupMaster.aspx.cs" Inherits="Design_Store_PharmacyMarkupMaster" %>

<%-- Add content controls here --%>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Pharmacy Markup Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Sub Category  
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlSubCategory" onchange="ddlSubcategoryChange()"></select>
                </div>

            </div>
            <div class="row">

                <div class="col-md-3">
                    <label class="pull-left">
                        From Range 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtFromRange" class="form-control btn-sm required number" style="float: left;"   maxlength="6" autocomplete="off" />

                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Range  
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtToRange" class="form-control btn-sm required number" style="float: left;"   maxlength="6" autocomplete="off" />

                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Type 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input id="txtFromulaType" type="text" class="form-control btn-sm required" />
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Formula 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtFromula" class="form-control btn-sm required number" style="float: left;"  maxlength="6" autocomplete="off" />

                </div>


            </div>


        </div>


        <div class="POuter_Box_Inventory" style="padding:5px">
            <div class="col-md-24" style="text-align: center">
                <input type="button" value="Save" id="btnSave" onclick="Save()" />
            </div>


            <div class="col-md-24" style="text-align: left">
                <b>Note For Type :- </b> <br /> <br />
                <b>1:- Enter  (*)  to Multiply.</b> <br />
                <b>2:- Enter (+) to Add.</b> <br />
                 <b>3:- Enter  (-)  to subtract.</b> <br />
                <b>4:- Enter (%) for Percentage.</b>

                </div>

        </div>

          <div class="POuter_Box_Inventory">
        <div id="divOutput" style="overflow-y:auto;overflow-x: auto;">
                           


                               
                                                
<table id="tblMarkup"  rules="all" border="1" style="border-collapse: collapse; width: 100%;display:none" class="GridViewStyle">
                               <thead>
    
<tr>
    <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">SN.</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">SubCategory</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none"">MarkupId</th> 
    <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none"">SubCategoryID</th> 

 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">FromRange</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">ToRange</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Type</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:left">Formula</th>  
<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Action</th>
 </tr>   
</thead>
<tbody></tbody>                            
</table>
              
                            </div>
         
          
          </div>



    </div>

    <script type="text/javascript">


        $(document).ready(function () {
            BindSubcategory();
            SearchData(0);
        });

        function BindSubcategory() {
            $subCategory = $('#ddlSubCategory');
            serverCall('PharmacyMarkupMaster.aspx/BindSubCategory', {}, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'NAME', isSearchAble: true });
            });
        }



        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }



        $('.number').keypress(function (event) {
            if ((event.which != 46 || $(this).val().indexOf('.') != -1) &&
              ((event.which < 48 || event.which > 57) &&
                (event.which != 0 && event.which != 8))) {
                event.preventDefault();
            }

            var text = $(this).val();

            if ((text.indexOf('.') != -1) &&
              (text.substring(text.indexOf('.')).length > 2) &&
              (event.which != 0 && event.which != 8) &&
              ($(this)[0].selectionStart >= text.length - 2)) {
                event.preventDefault();
            }
        });


        function clear() {

            $("#txtFromRange").val("");
            $("#txtToRange").val("");
            $("#txtFromulaType").val("");
            $("#txtFromula").val("");

        }

        function Save() {

            var data = new Object();
            data.SubCategory = $("#ddlSubCategory").val();
            data.FromRange = $("#txtFromRange").val();
            data.ToRange = $("#txtToRange").val();
            data.Type = $("#txtFromulaType").val();
            data.Formula = $("#txtFromula").val();

            if (data.SubCategory == "" || data.SubCategory == "0" || data.SubCategory == undefined || data.SubCategory == null) {

                modelAlert("Select SubCategory.")

                return false;
            }
            if (data.FromRange == ""  || data.FromRange == undefined || data.FromRange == null) {

                modelAlert("Select Enter From Range.")

                return false;
            }

            if (data.ToRange == "" || data.ToRange == undefined || data.ToRange == null) {

                modelAlert("Enter To Range.")

                return false;
            }

            if (data.Type == "" || data.Type == undefined || data.Type == null) {

                modelAlert("Enter Type.")

                return false;
            }

            if (data.Formula == "" || data.Formula == undefined || data.Formula == null) {

                modelAlert("Enter Formula.")

                return false;
            }
            if (parseFloat(data.ToRange) < parseFloat(data.FromRange)) {
                modelAlert("ToRange must be more then FromRange.")
                return false;
            }

            if (data.Type == "%" || data.Type == "*" || data.Type == "+" || data.Type == "-") {

            }
            else {
                modelAlert("Enter Valid Type.")
                return false;
            }



            $('#btnSave').attr('disabled', true).val("Submitting...");



            $.ajax({
                url: "PharmacyMarkupMaster.aspx/InsertPharmacyMarkupMaster",
                data: JSON.stringify({ Data: data }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                async: false,
                dataType: "json",
                success: function (result) {

                    var responseData = JSON.parse(result.d);
                    var btnSave = $('#btnSave');

                    modelAlert(responseData.response, function () {

                        if (responseData.status) {
                            clear();
                            SearchData($("#ddlSubCategory").val());
                            $(btnSave).removeAttr('disabled').val('Save');
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');

                    });



                }
            });

        }

        function ddlSubcategoryChange() {
            SearchData($("#ddlSubCategory").val());
        }



        function SearchData(id) {


            serverCall('PharmacyMarkupMaster.aspx/GetDataToFill', { Id: id }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#tblMarkup tbody').empty();
                    $.each(data, function (i, item) {

                        var rdb = '';
                        rdb += '<tr>';
                        rdb += '<td class="GridViewItemStyle">' + ++count + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.SubCategory + '</td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblId">' + item.Id + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblSubCategoryId">' + item.SubcategoryId + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle">' + item.FromRange + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.ToRange + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.TypeOfFormula + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.Formula + '</td>';
                        rdb += '<td class="GridViewItemStyle"><input type="button" value="Remove" id="btnRemove" onclick="Remove(' + item.Id + ')" /></td>';

                        rdb += '</tr> ';

                        $('#tblMarkup tbody').append(rdb);

                    });

                    $('#tblMarkup').show();
                }
                else {
                    $('#tblMarkup tbody').empty();
                    $('#tblMarkup').hide();
                }
            });
        }

        function Remove(Id) {
            modelConfirmation('Confirmation!!!', 'Are You Sure You Want To Remove This Range', 'Continue', 'Close', function (response) {
                if (response) {
                    serverCall('PharmacyMarkupMaster.aspx/RemoveRange', { Id: Id }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            modelAlert(responseData.response, function () {
                                SearchData($("#ddlSubCategory").val());
                            });
                        }
                        else {

                            modelAlert(responseData.response);
                        }
                    });
                }
            });
        }
    </script>
</asp:Content>
