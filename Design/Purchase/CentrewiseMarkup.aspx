<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CentrewiseMarkup.aspx.cs" Inherits="Design_Purchase_CentrewiseMarkup" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />

    <script type="text/javascript">

        $(document).ready(function () {
            $bindCentre(function () {
                $bindCategory(function () {
                    $('#dvList,#dvSave').hide();
                    
                    var isCentreWiseSubCategoryWise = Number('<%= Resources.Resource.IsCentrewiseSubCategoryWiseMarkup%>');
                    if (isCentreWiseSubCategoryWise == 1) {
                        $(".isCentreWise").show();
                    }
                    else {
                        $(".isCentreWise").hide();
                    }
                });
            });

        });

        var $bindCentre = function (callback) {
            serverCall('Services/CentrewiseMarkup.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                var DefaultValue = "Select";
                var isCentreWiseSubCategoryWise = Number('<%= Resources.Resource.IsCentrewiseSubCategoryWiseMarkup%>');
                if (isCentreWiseSubCategoryWise == 0)
                    DefaultValue = "Universal";
                $Centre.bindDropDown({ defaultValue: DefaultValue, data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: DefaultValue });
                callback($Centre.find('option:selected').text());
            });
        }
        var $SearchMarkupDetails = function (callback) {
            $('#lblMsg').text('');
            var isCentreWiseSubCategoryWise = Number('<%= Resources.Resource.IsCentrewiseSubCategoryWiseMarkup%>');
            if (isCentreWiseSubCategoryWise == 1) {
                if ($('#ddlCentre').val() == "0") {
                    $('#lblMsg').text('Please Select Centre');
                    return false;
                }
            }
            else {
                if ($('#ddlCentre').val() != "0") {
                    $('#lblMsg').text('Set Only Universal Sub Category wise Markup');
                    return false;
                }

            }
            if ($('#ddlCategory').val() == "0") {
                $('#lblMsg').text('Please Select Category');
                return false;
            }
            if ($('#ddlSubCategory').val() == "0") {
                $('#lblMsg').text('Please Select Sub Category');
                return false;
            }

            data = {
                centreID: Number($('#ddlCentre').val()),
                categoryID: $('#ddlCategory').val(),
                subcategoryID: $('#ddlSubCategory').val()
            };

            serverCall('Services/CentrewiseMarkup.asmx/SearchMarkupDetails', data, function (response) {
                MarkupDetails = JSON.parse(response);
                var outputMarkupDetails = $('#tb_MarkupDetails').parseTemplate(MarkupDetails);
                $('#dvMarkupList').html(outputMarkupDetails).customFixedHeader();
                var rowNo = Number($("#tableMarkupDetails tbody tr").length);
                if(rowNo>1)
                    $("#tableMarkupDetails tbody tr").not(':last').find('.imgPlus').hide();

                $('#dvList,#dvSave').show();
            });
        }

        var $bindCategory = function (callback) {
            serverCall('../common/CommonService.asmx/BindCategory', { Type: '7' }, function (response) {
                $Category = $('#ddlCategory');
                $Category.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                if ($Category.val() != "0") {
                    $bindSubCategory($Category.val(), function () {
                        callback($Category.find('option:selected').text());

                    });
                }

            });
        }
        $bindSubCategory = function (categoryID, callback) {
            if (categoryID == 0)
                categoryID = '';
            $subCategory = $('#ddlSubCategory');
            serverCall('../common/CommonService.asmx/BindSubCategory', { Type: '7', CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                callback($subCategory.find('option:selected').text());
                $SearchMarkupDetails();
            });
        }

        function DeleteRow(rowid) {
            $(rowid).closest("tr").remove();
            $("#tableMarkupDetails tbody tr:last").find('.imgPlus').show();
            $("#tableMarkupDetails tbody tr:last").find('.IsEdittable').removeAttr('disabled');
        }
        function AddRow(rowid) {
            $('#lblMsg').text('');
            if (Number($(rowid).closest("tr").find('#txtToRate').val()) < Number($(rowid).closest("tr").find('#tdFromRate').text()))
            {
                $('#lblMsg').text('To Rate should be greater than or equal to From Rate');
                $(rowid).closest("tr").find('#txtToRate').focus();
                return false;
            }

            $("#tableMarkupDetails").find('.imgPlus').hide();
            $("#tableMarkupDetails").find('.IsEdittable').attr('disabled', true);

         var FromRate= Number($(rowid).closest("tr").find('#txtToRate').val());
         var rowNo = Number($("#tableMarkupDetails tbody tr").length) + 1;

            $("#tableMarkupDetails tbody").append("  <tr onmouseover='this.style.color='#00F'' onMouseOut='this.style.color=''' style='cursor:pointer;' id="+ rowNo +" >  " +
            " <td  class='GridViewLabItemStyle' id='tdSRNo' style='text-align:center;' >" + rowNo + "</td>  " +
            " <td class='GridViewLabItemStyle' id='tdFromRate' style='text-align:right; '>" + FromRate + "</td> " +
            " <td class='GridViewLabItemStyle' id='tdToRate' style='text-align:right; '> <input id='txtToRate' style='text-align:left;' onlynumber='14' decimalplace='4' max-value='10000000' onkeypress='$commonJsNumberValidation(event)' onkeydown='$commonJsPreventDotRemove(event)' class='requiredField IsEdittable' type='text' title='Enter To Rate' /> </td> " +
            " <td class='GridViewLabItemStyle' id='tdMarkUpPercentage' style='text-align:right; '> <input id='txtMarkUpPercentage' style='text-align:left;' onlynumber='10' decimalplace='4' max-value='100' onkeypress='$commonJsNumberValidation(event)' onkeydown='$commonJsPreventDotRemove(event)' class='requiredField' type='text' value='0' title='Enter Markup %' /> </td> " +
           
            " <td class='GridViewLabItemStyle'><img alt='' src='../../Images/Post.gif' class='imgPlus' title='Add New Row' style='cursor:pointer' onclick='AddRow(this)'  /></td> " +
             " <td class='GridViewLabItemStyle'><img alt='' src='../../Images/Delete.gif' class='imgPlus' title='Delete Row' style='cursor:pointer' onclick='DeleteRow(this)'  /></td> " +

           " <td class='GridViewLabItemStyle' id='tdID' style='display:none;'>0</td> " +
            " </tr> ");
        }

        function savePerformingItems() {
            $('#lblMsg').text('');
            var isCentreWiseSubCategoryWise = Number('<%= Resources.Resource.IsCentrewiseSubCategoryWiseMarkup%>');
            if (isCentreWiseSubCategoryWise == 1) {
                if ($('#ddlCentre').val() == "0") {
                    $('#lblMsg').text('Please Select Centre');
                    return false;
                }
            }
            if ($('#ddlCategory').val() == "0") {
                $('#lblMsg').text('Please Select Category');
                return false;
            }
            if ($('#ddlSubCategory').val() == "0") {
                $('#lblMsg').text('Please Select Sub Category');
                return false;
            }

            var IsRateCheck=0,SelectedRowid="";
            $('#tableMarkupDetails tbody tr').each(function (index, row) {
                if (Number($.trim($(row).find('#tdFromRate').text())) > Number($.trim($(row).find('#txtToRate').val())))
                { IsRateCheck = 1;
                    SelectedRowid = row;
                }
            });

            if (IsRateCheck == 1) {
                $('#lblMsg').text('To Rate should be greater than or equal to From Rate');
                $(SelectedRowid).find('#txtToRate').focus();
                return false;
            }

            $('#btnSave').attr('disabled', true).val('Submitting...');

            $MarkUp = [];
            $('#tableMarkupDetails tbody tr').each(function (index, row) {
                $MarkUp.push({
                    centreID: $.trim($('#ddlCentre').val()),
                    SubCategoryID: $.trim($('#ddlSubCategory').val()),
                    CategoryID: $.trim($('#ddlCategory').val()),
                    FromRate: Number($.trim($(row).find('#tdFromRate').text())),
                    ToRate: Number($.trim($(row).find('#txtToRate').val())),
                    MarkupPer: Number($.trim($(row).find('#txtMarkUpPercentage').val())),
                });
            });

            serverCall('Services/CentrewiseMarkup.asmx/saveMarkup', { MarkUpList: $MarkUp }, function (response) {
                $responseData = JSON.parse(response);
                modelAlert($responseData.response, function (response) {
                    $SearchMarkupDetails();
                    $('#btnSave').removeAttr('disabled').val('Save');
                });
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Centre wise Markup Setting </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Category
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCategory" runat="server" ClientIDMode="Static" onchange="$bindSubCategory($('#ddlCategory').val(),function(){});" TabIndex="2" ToolTip="Select Category"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Sub Category
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlSubCategory" onchange="$SearchMarkupDetails();" runat="server" ClientIDMode="Static" TabIndex="3" ToolTip="Select SubCategory"></asp:DropDownList>
                </div>
                <div class="col-md-3 isCentreWise">
                    <label class="pull-left">
                        Centre Name 
                    </label>
                    <b class="pull-right isCentreWise">:</b>
                </div>
                <div class="col-md-5 isCentreWise" >
                    <asp:DropDownList ID="ddlCentre" runat="server" onchange="$SearchMarkupDetails();" ClientIDMode="Static" TabIndex="1" ToolTip="Select Centre"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="display:none;">
            <div class="row">
                <div class="col-md-24 textCenter">
                    <input type="button" id="btnSearch" onclick="$SearchMarkupDetails()" class="save" value="Search" tabindex="6" />
                </div>
            </div>
        </div>
         <div class="POuter_Box_Inventory" id="dvList" style="display:none;">
              <div class="Purchaseheader">
                Markup List
            </div>
            <div class="row" >
                <div class="col-md-24" style="text-align:center;">
                    <div id="dvMarkupList" ></div>
                </div>
            </div>
        </div>
         <div class="POuter_Box_Inventory" id="dvSave" style="display:none;">
            <div class="row">
                <div class="col-md-24 textCenter">
                    <input type="button" id="btnSave" onclick="savePerformingItems()" class="save" value="Save" tabindex="7" />
                </div>
            </div>
        </div>
    </div>

    <script id="tb_MarkupDetails" type="text/html">
        <table  id="tableMarkupDetails" cellspacing="0" rules="all" border="1" style="width:50%;border-collapse :collapse;">
            <thead>
                <tr id="TrHeader">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;width: 10px;"  >S/No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">From Rate</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">To Rate</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">MarkUp(%)</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;"></th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;"></th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">Id</th>
                </tr>
            </thead>
            <tbody>
            <#                       
                var dataLength=MarkupDetails.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = MarkupDetails[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" id="<#=j+1#>"
                     <#if(objRow.ID!="0"){#> style='cursor:pointer;background-color:lightgreen;' <#} else {#> style='cursor:pointer;' <#} #>  >   
                                                                             
                    <td  class="GridViewLabItemStyle" id="tdSRNo"style="text-align:center;width: 10px;" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdFromRate" style="text-align:right;" ><#=objRow.FromRate#></td>
                    <td class="GridViewLabItemStyle" id="tdToRate" style="text-align:right;" >
                        <input type="text" id="txtToRate" class="requiredField IsEdittable" onlynumber="14" style="text-align:left;" decimalplace="4" max-value="10000000" onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" title="Enter To Rate" style="text-align:right;" value='<#=objRow.ToRate#>'  />
                    </td>
                    <td class="GridViewLabItemStyle" id="tdMarkUpPercentage" style="text-align:right;" >
                            <input type="text" id="txtMarkUpPercentage" class="requiredField"  style="text-align:left;" onlynumber="10" decimalplace="4" max-value="100" onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" title="Enter MarkUp(%)" style="text-align:right;" value='<#=objRow.MarkUpPercentage#>'  />
                    </td>
                    <td class="GridViewLabItemStyle" style="width:5px;">
                     <img alt="" src="../../Images/Post.gif" class="imgPlus" title="Add New Row" style="cursor:pointer" onclick="AddRow(this)"  /></td>

                       <td class="GridViewLabItemStyle" style="width:5px;">
                     <img alt="" src="../../Images/Delete.gif" class="imgPlus" title="Delete Row" style="cursor:pointer" onclick="DeleteRow(this)"  /></td>

                    <td class="GridViewLabItemStyle" id="tdID" style="width:80px;display:none"><#=objRow.ID#></td>                         
                </tr>            
            <#}#>
            </tbody>      
        </table>
         </script>

</asp:Content>

